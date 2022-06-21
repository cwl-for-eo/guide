class: CommandLineTool
 
requirements:
  DockerRequirement: 
    dockerPull: docker.io/terradue/jq
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}

baseCommand: curl
arguments:
- -s
- $(inputs.stac_item)
- "|"
- jq
- .assets.$(inputs.asset).href

stdout: message

inputs:
  stac_item:
    type: string
  asset:
    type: string

outputs:

  asset_href: 
    type: string
    outputBinding:
      glob: message
      loadContents: true
      outputEval: $( "/vsicurl/" + self[0].contents.replace('"', '').split("\n").join("").replace('"', '') ) 
      
cwlVersion: v1.0