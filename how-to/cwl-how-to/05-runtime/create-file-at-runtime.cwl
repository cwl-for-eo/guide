cwlVersion: v1.0

$graph:
- class: Workflow

  id: main

  requirements: 
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement

  inputs:

    red: 
      type: string
    green: 
      type: string
    blue: 
      type: string

  outputs:

    preview: 
      outputSource: node_gdal/preview
      type: File[]

  steps:

    node_gdal:

      in: 
        band: [red, green, blue]
        
      out: 
      - preview

      run:
        "#gdal"

      scatter: band
      scatterMethod: dotproduct 


- class: CommandLineTool
  
  id: gdal

  requirements:
    InlineJavascriptRequirement: {}
    EnvVarRequirement:
      envDef:
        PROJ_LIB: /srv/conda/envs/notebook/share/proj
    InitialWorkDirRequirement:
      listing:
        - entryname: run.sh
          entry: |-
            gdal_translate \
              -of PNG \
              -ot Byte \
              -srcwin 1000 1000 500 500 \
              $( inputs.band ) \
              $( inputs.band.split("/").slice(-1)[0].replace(".tif", ".png") )
  hints:
    DockerRequirement: 
      dockerPull: docker.io/osgeo/gdal          
  
  baseCommand: ['/bin/sh', 'run.sh']

  arguments: []
  
  inputs:

    band: 
      type: string

  outputs:

    preview: 
      type: File
      outputBinding:
        glob: "*.png"