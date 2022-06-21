cwlVersion: v1.0

$graph:
- class: Workflow

  id: main

  requirements: 
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

  inputs:

    stac_item: 
      type: string

  outputs:

    tif:
      outputSource: node_translate/tif
      type: File

  steps:

    node_stac:

      in: 
        stac_item: stac_item

      out: 
      - asset

      run:
        "#stac"
    
    node_translate:

      in:
        asset: 
          source: node_stac/asset

      out: 
      - tif

      run: 
        "#translate"

- class: CommandLineTool
  
  id: stac

  requirements:
    InlineJavascriptRequirement: {}
    DockerRequirement: 
      dockerPull: docker.io/curlimages/curl:latest

  baseCommand: curl

  stdout: message

  arguments: 
  - $( inputs.stac_item )

  inputs:

    stac_item:
      type: string

  outputs:

    asset: 
      type: Any
      outputBinding:
        glob: message
        loadContents: true
        outputEval: |
          ${ 
              return JSON.parse(self[0].contents).assets; 
            }

- class: CommandLineTool
  
  id: translate

  requirements:
    InlineJavascriptRequirement: {}
    DockerRequirement: 
      dockerPull: docker.io/osgeo/gdal:latest

  baseCommand: gdal_translate

  arguments: 
  - valueFrom: |
     $( '/vsicurl/' +  inputs.asset.B01.href )
  - valueFrom: ${ return inputs.asset.B01.href.split("/").slice(-1)[0]; }


  inputs:

    asset:
      type: Any

  outputs:

    tif: 
      type: File
      outputBinding:
        glob: "*.tif"
