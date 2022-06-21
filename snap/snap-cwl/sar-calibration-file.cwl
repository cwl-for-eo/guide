$graph:
- class: Workflow
  id: main
  doc: SNAP Sentinel-1 GRD Calibration
  label: SNAP Sentinel-1 GRD Calibration

  inputs:

    polarization:
      doc: Polarization channel 
      label: Polarization channel 
      type: string

    snap_graph:
      doc: SNAP Graph
      label: SNAP Graph
      type: File

    safe:
      doc: Sentinel-1 GRD product SAFE Directory
      label: Sentinel-1 GRD product SAFE Directory
      type: Directory
  
  outputs:
  - id: wf_outputs
    outputSource:
    - node_1/results
    type: Directory
  
  requirements:
    SubworkflowFeatureRequirement: {}
  
  steps:
    
    node_1:
      in:
        snap_graph: snap_graph
        polarization: polarization
        safe: safe
      out:
      - results
      run: '#sar-calibration'

- class: CommandLineTool
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
  
  stderr: std.err
  stdout: std.out

cwlVersion: v1.0