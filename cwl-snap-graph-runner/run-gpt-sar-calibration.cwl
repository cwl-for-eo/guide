$graph:

- baseCommand: gpt
  hints:
    DockerRequirement:
      dockerPull: docker.pkg.github.com/snap-contrib/docker-snap/snap:latest
  class: CommandLineTool
  id: clt
  inputs:
    inp1:
      inputBinding:
        position: 1
      type: File
    inp2:
      inputBinding:
        position: 2
        prefix: -PselPol=
        separate: false
      type: string
    inp3:
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
  requirements:
    EnvVarRequirement:
      envDef:
        PATH: /srv/conda/envs/env_snap/snap/bin:/usr/share/java/maven/bin:/usr/share/java/maven/bin:/opt/anaconda/bin:/opt/anaconda/condabin:/opt/anaconda/bin:/usr/lib64/qt-3.3/bin:/usr/share/java/maven/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
        PREFIX: /opt/anaconda/envs/env_snap
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out

- class: Workflow
  id: main
  doc: SNAP SAR Calibration
  label: SNAP SAR Calibration
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
      type: Directory[]
  
  outputs:
  - id: wf_outputs
    outputSource:
    - node_1/results
    type:
      items: Directory
      type: array
  
  requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement
  
  steps:
    
    node_1:
      in:
        inp1: snap_graph
        inp2: polarization
        inp3: safe
      out:
      - results
      run: '#clt'
      scatter: inp3
      scatterMethod: dotproduct
cwlVersion: v1.0
