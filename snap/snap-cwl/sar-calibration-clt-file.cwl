class: CommandLineTool
id: sar-calibration
requirements:
  DockerRequirement:
    dockerPull: snap-gpt
  EnvVarRequirement:
    envDef:
      PATH: /srv/conda/envs/env_snap/snap/bin:/usr/share/java/maven/bin:/usr/share/java/maven/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
  ResourceRequirement: {}
baseCommand: gpt
inputs:
  snap_graph:
    inputBinding:
      position: 1
    type: File
  polarization:
    inputBinding:
      position: 2
      prefix: -PselPol=
      separate: false
    type: string
  safe:
    inputBinding:
      position: 2
      prefix: -PinFile=
      separate: false
    type: Directory
outputs:
  results:
    outputBinding:
      glob: .
    type: Directory

cwlVersion: v1.0
