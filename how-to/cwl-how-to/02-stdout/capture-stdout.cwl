cwlVersion: v1.0

$graph:
- class: Workflow
  id: main

  inputs:

    tif: 
      type: string

  outputs:

    info: 
      outputSource: gdal-info/info
      type: string

  steps:

    gdal-info:

      in: 
        tif: tif

      out: 
      - info

      run:
        "#gdal"

- class: CommandLineTool
  
  id: gdal

  requirements:
    InlineJavascriptRequirement: {}
    EnvVarRequirement:
      envDef:
        PROJ_LIB: /srv/conda/envs/notebook/share/proj
  hints:
    DockerRequirement: 
      dockerPull: docker.io/osgeo/gdal  

  baseCommand: gdalinfo

  stdout: message 

  arguments: 
  - valueFrom: |
        ${ if (inputs.tif.startsWith("http")) {
             return "/vsicurl/" + inputs.tif; 
           } else { 
             return inputs.tif;
           } 
        }

  inputs:

    tif:
      type: string

  outputs:

    info: 
      type: Any
      outputBinding:
        glob: message
        loadContents: true
        outputEval:  $( self[0].contents )