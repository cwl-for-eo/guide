$graph:
- class: Workflow
  label: Mosaics two or more Landsat-8 acquisitions (includes pan-sharpening)
  doc: Mosaics two or more Landsat-8 acquisitions (includes pan-sharpening)
  id: main

  requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement

  inputs:
    stac_items: 
      doc: Landsat-8 item
      type: string[]
  
  outputs:
    mosaic:
      outputSource:
      - node_mosaic/mosaic
      type: File

  steps:

    node_ps:
    
      run: pan-sharpening.cwl
        
      in:
        stac_item: stac_items
        
      out:
        - ps_tif

      scatter: stac_item
      scatterMethod: dotproduct

    node_mosaic:

      run: aggregate.cwl

      in: 
        tifs:
          source: [node_ps/ps_tif]

      out:
        - mosaic

cwlVersion: v1.0