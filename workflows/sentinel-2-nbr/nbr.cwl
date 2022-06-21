
class: Workflow
label: NBR - produce the normalized difference between NIR and SWIR 22 
doc: NBR - produce the normalized difference between NIR and SWIR 22 
id: main

requirements:
- class: ScatterFeatureRequirement

inputs:
  stac_item: 
    doc: Sentinel-2 item
    type: string
  aoi: 
    doc: area of interest as a bounding box
    type: string
  bands: 
    type: string[]
    default: ["B8A", "B12", "SCL"]
  
outputs:
  nbr:
    outputSource:
    - node_nbr/nbr
    type: File

steps:

  node_stac:
    
    run: asset.cwl
        
    in:
      stac_item: stac_item
      asset: bands

    out:
      - asset_href

    scatter: asset
    scatterMethod: dotproduct 

  node_subset:

    run: translate.cwl  

    in: 
      asset: 
        source: node_stac/asset_href
      bbox: aoi

    out:
    - tifs
        
    scatter: asset
    scatterMethod: dotproduct

  node_nbr:
    
    run: band_math.cwl

    in:
      stac_item: stac_item
      tifs: 
        source: [node_subset/tifs]
      
    out:
    - nbr

cwlVersion: v1.0