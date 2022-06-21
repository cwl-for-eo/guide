cwlVersion: v1.2

$graph:
- class: Workflow

  id: main

  requirements: 
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement

  inputs:

    red: 
      type: string
    green: 
      type: string
    blue: 
      type: string
    epsg_code: 
      type: string

  outputs:

    preview: 
      type: File[]
      outputSource: 
      - node_warp/preview
      - node_translate/preview
      pickValue: all_non_null
      linkMerge: merge_flattened

  steps:

    node_translate:

      in: 
        band: [red, green, blue]
        epsg_code: epsg_code
      out: 
      - preview

      run:
        "#translate"

      when: $( inputs.epsg_code == "native")


      scatter: band
      scatterMethod: dotproduct 

    node_warp:

      in: 
        band: [red, green, blue]
        epsg_code: epsg_code
        
      out: 
      - preview

      run:
        "#warp"

      when: $( inputs.epsg_code != "native")

      scatter: band
      scatterMethod: dotproduct

- class: CommandLineTool
  
  id: translate

  requirements:
    InlineJavascriptRequirement: {}
    EnvVarRequirement:
      envDef:
        PROJ_LIB: /srv/conda/envs/notebook/share/proj
    NetworkAccess:
      networkAccess: true
  hints: 
    DockerRequirement: 
      dockerPull: docker.io/osgeo/gdal 
      
  baseCommand: gdal_translate

  arguments: 
  - -of
  - COG
  - -ot 
  - Byte
  - valueFrom: $( inputs.band )
  - valueFrom: $( inputs.band.split("/").slice(-1)[0] )

  inputs:

    band: 
      type: string

  outputs:

    preview: 
      type: File
      outputBinding:
        glob: "*.tif"


- class: CommandLineTool
  
  id: warp
  
  requirements:
    InlineJavascriptRequirement: {}
    EnvVarRequirement:
      envDef:
        PROJ_LIB: /srv/conda/envs/notebook/share/proj
    NetworkAccess:
      networkAccess: true
  hints:
    DockerRequirement: 
      dockerPull: docker.io/osgeo/gdal  

  baseCommand: gdalwarp

  arguments: 
  - -of
  - COG
  - -ot 
  - Byte
  - -t_srs 
  - valueFrom: $( inputs.epsg_code )
  - valueFrom: $( inputs.band )
  - valueFrom: $( inputs.band.split("/").slice(-1)[0].replace(".TIF", ".tif") )

  inputs:

    band: 
      type: string
    epsg_code:
      type: string

  outputs:

    preview: 
      type: File
      outputBinding:
        glob: "*.tif"