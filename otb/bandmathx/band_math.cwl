class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement: 
    dockerPull: docker.io/terradue/otb-7.2.0

baseCommand: otbcli_BandMathX
arguments: 
- -out
- valueFrom: ${ return inputs.stac_item.split("/").slice(-1)[0] + ".tif"; }
- -exp
- '(im3b1 == 8 or im3b1 == 9 or im3b1 == 0 or im3b1 == 1 or im3b1 == 2 or im3b1 == 10 or im3b1 == 11) ? -2 : (im1b1 - im2b1) / (im1b1 + im2b1)'

inputs:

  tifs:
    type: string[]
    inputBinding:
      position: 5
      prefix: -il
      separate: true
  
  stac_item:
    type: string
    
outputs:

  nbr:
    outputBinding:
      glob: "*.tif"
    type: File

cwlVersion: v1.0