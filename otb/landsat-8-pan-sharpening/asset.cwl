class: CommandLineTool
 
requirements:
  DockerRequirement: 
    dockerPull: terradue/jq
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}

baseCommand: curl
arguments:
- -s
- $(inputs.stac_item)
- "|"
- jq
- .assets.$(inputs.asset).href
- "|"
- tr 
- -d
- '\"' #\""

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
      outputEval: $( self[0].contents.split("\n").join("") )

cwlVersion: v1.0