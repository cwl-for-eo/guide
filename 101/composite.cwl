class: Workflow
label: Sentinel-2 RGB creation
doc:  This worflow creates an RGB composite
id: main

requirements:
- class: ScatterFeatureRequirement

inputs:

  geotiffs:
    doc: list of geotifs
    type: File[]

  bbox: 
    doc: area of interest as a bounding box
    type: string
  
  epsg:
    doc: EPSG code 
    type: string
    default: "EPSG:4326"

outputs:
  rgb:
      outputSource:
      - node_concatenate/composite
      type: File

steps:

  node_translate:
    
    run: translate.cwl
        
    in:
 
      geotiff: geotiffs  
      bbox: bbox
      epsg: epsg

    out:
    - clipped_tif

    scatter: geotiff
    scatterMethod: dotproduct

  node_concatenate:

    run: concatenate.cwl

    in: 
      tifs:
        source: node_translate/clipped_tif

    out:
    - composite


cwlVersion: v1.0