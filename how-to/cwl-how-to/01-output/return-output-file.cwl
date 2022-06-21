cwlVersion: v1.0

$graph:
- class: Workflow
  id: main
  inputs:
    tif: 
      type: string
  outputs:
    preview: 
      outputSource: node_gdal/preview
      type: File
  steps:
    node_gdal:
      in: 
        tif: tif
      out: 
      - preview
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
  baseCommand: gdal_translate
  arguments: 
  - -of
  - PNG
  - -ot 
  - Byte
  - valueFrom: |
        ${ if (inputs.tif.startsWith("http")) {
             return "/vsicurl/" + inputs.tif; 
           } else { 
             return inputs.tif;
           } 
        }
  - preview.png
  inputs:
    tif:
      type: string
  outputs:
    preview: 
      type: File
      outputBinding:
        glob: preview.png