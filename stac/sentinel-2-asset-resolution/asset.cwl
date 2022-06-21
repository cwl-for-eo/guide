$graph:
- class: Workflow
  label: Resolve STAC asset href
  doc: This workflow resolves a STAC asset href using its key 
  id: main

  inputs:
    stac_item:
      type: string
    asset:
      type: string

  outputs:
    asset_href:
      outputSource:
      - node_stac/asset_href
      type: string

  steps:

    node_stac:

      run: "#asset"

      in:
        stac_item: stac_item
        asset: asset

      out:
        - asset_href

- class: CommandLineTool
  id: asset

  requirements:
    DockerRequirement: 
      dockerPull: terradue/jq
    ShellCommandRequirement: {}
    InlineJavascriptRequirement: {}

  baseCommand: curl
  arguments:
  - -s
  - valueFrom: ${ return inputs.stac_item; }
  - "|"
  - jq
  - valueFrom: ${ return ".assets." + inputs.asset + ".href"; }
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