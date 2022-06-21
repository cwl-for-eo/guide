class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement: 
    dockerPull: terradue/otb-7.2.0

baseCommand: otbcli_ConcatenateImages
arguments: 
- -out
- xs_stack.tif

inputs:

  tifs:
    type: File[]
    inputBinding:
      position: 5
      prefix: -il
      separate: true
      
outputs:

  xs_stack:
    outputBinding:
      glob: "xs_stack.tif"
    type: File

stderr: stderr
stdout: stdout

cwlVersion: v1.0