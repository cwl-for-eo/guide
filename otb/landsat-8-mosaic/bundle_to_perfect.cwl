class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement: 
    dockerPull: terradue/otb-7.2.0

baseCommand: otbcli_BundleToPerfectSensor
arguments: 
- -out
- pan-sharpen.tif

inputs:

  xs:
    type: File
    inputBinding:
      position: 2
      prefix: -inxs
      separate: true
      
  pan:
    type: string
    inputBinding:
      position: 3
      prefix: -inp
      separate: true

outputs:

  pan-sharpened:
    outputBinding:
      glob: "*.tif"
    type: File

cwlVersion: v1.0