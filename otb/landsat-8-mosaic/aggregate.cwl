class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement: 
    dockerPull: terradue/otb-7.2.0

baseCommand: otbcli_Mosaic
arguments: 
- -out
- mosaic.tif

inputs:

  tifs:
    type: File[]
    inputBinding:
      position: 3
      prefix: -il
      separate: true
      
outputs:

  mosaic:
    outputBinding:
      glob: "mosaic.tif"
    type: File

cwlVersion: v1.0