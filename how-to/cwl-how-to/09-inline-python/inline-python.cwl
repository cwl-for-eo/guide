cwlVersion: v1.0


$namespaces:
  s: https://schema.org/
s:softwareVersion: 1.1.6
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf


$graph:

- class: Workflow
 
  id: main

  requirements:
  - class: ScatterFeatureRequirement
  
  inputs:
    aoi: 
      doc: area of interest as a bounding box
      type: string

    epsg:
      doc: EPSG code 
      type: string
      default: "EPSG:4326"

    bands: 
      doc: bands used for the NDWI
      type: string[]
      default: ["green", "nir"]

    stac_item:
      doc: STAC item
      type: string

  outputs:
    - id: cropped
      outputSource: 
      - node_crop/cropped
      type: File[]

  steps:

    node_crop:

      run: "#crop"

      in:
        item: stac_item
        aoi: aoi
        epsg: epsg
        band: 
          default: ["green", "nir"]

      out:
        - cropped

      scatter: band
      scatterMethod: dotproduct
    
- class: CommandLineTool
  id: crop

  requirements:
    InlineJavascriptRequirement: {}
    EnvVarRequirement:
      envDef:
        PYTHONPATH: $HOME
        PROJ_LIB: /srv/conda/envs/notebook/share/proj
    InitialWorkDirRequirement:
      listing:
        - entryname: run.sh
          entry: |-
            python -m app $@
        - entryname: app.py
          entry: |-
            import click
            from urllib.parse import urlparse
            from osgeo import gdal
            import pystac

            settings = None

            def aoi2box(aoi):
                return [float(c) for c in aoi.split(",")]


            def get_common_name(asset):
                if "eo:bands" in asset.to_dict().keys():
                    if "common_name" in asset.to_dict()["eo:bands"][0].keys():
                        return asset.to_dict()["eo:bands"][0]["common_name"]
                return None


            def get_asset(item, common_name):

                for _, asset in item.get_assets().items():
                    if not "data" in asset.to_dict()["roles"]:
                        continue
                    eo_asset = pystac.extensions.eo.AssetEOExtension(asset)
                    if not eo_asset.bands:
                        continue
                    for b in eo_asset.bands:
                        if (
                            "common_name" in b.properties.keys()
                            and b.properties["common_name"] == common_name
                        ):
                            return asset


            def vsi_href(uri):
                parsed = urlparse(uri)
                if parsed.scheme.startswith("http"):
                    return "/vsicurl/{}".format(uri)
                else:
                    return uri


            @click.command(
                short_help="Crop",
                help="Crops a STAC Item asset defined with its common band name",
            )
            @click.option(
                "--input-item",
                "item_url",
                help="STAC Item URL",
                required=True,
            )
            @click.option(
                "--aoi",
                "aoi",
                help="Area of interest expressed as a bounding box",
                required=True,
            )
            @click.option(
                "--epsg",
                "epsg",
                help="EPSG code",
                required=True,
            )
            @click.option(
                "--band",
                "band",
                help="Common band name",
                required=True,
            )
            def crop(item_url, aoi, band, epsg):

                item = pystac.read_file(item_url)
                asset = get_asset(item, band)
                asset_href = vsi_href(asset.href)
                bbox = aoi2box(aoi)
                ds = gdal.Open(asset_href)
                gdal.Translate(
                    f"crop_{band}.tif",
                    ds,
                    projWin=[bbox[0], bbox[3], bbox[2], bbox[1]],
                    projWinSRS=epsg,
                )

            if __name__ == "__main__":
                crop()
  baseCommand: ['/bin/sh', 'run.sh']  
  arguments: []
  inputs:
    item:
      type: string
      inputBinding:
        prefix: --input-item
    aoi:
      type: string
      inputBinding:
        prefix: --aoi
    epsg:
      type: string  
      inputBinding:
        prefix: --epsg
    band:
      type: string  
      inputBinding:
        prefix: --band
  outputs: 
    cropped:
      outputBinding:
        glob: '*.tif'
      type: File

