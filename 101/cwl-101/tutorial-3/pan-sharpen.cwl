$graph:
- class: Workflow
  label: Landsat-8 pan-sharpening  
  doc: Landsat-8 pan-sharpening  
  id: main

  requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement


  inputs:
    stac_item: 
      doc: Landsat-8 item
      type: string
    bbox: 
      doc: area of interest as a bounding box
      type: string
    red: 
      type: string
      default: "B4"
    green: 
      type: string
      default: "B3"
    blue: 
      type: string
      default: "B2"
    pan:
      type: string
      default: "B8"
  
  outputs:
    ps_tif:
      outputSource:
      - node_bundle_to_perfect/pan-sharpened
      type: File

  steps:

    node_stac_xs:
    
      run: asset.cwl
        
      in:
        stac_item: stac_item
        asset: [red, green, blue]

      out:
        - asset_href

      scatter: asset
      scatterMethod: dotproduct 
    
    node_stac_pan:
    
      run: asset.cwl
        
      in:
        stac_item: stac_item
        asset: pan

      out:
        - asset_href

    node_subset_xs:

      run: translate.cwl  

      in: 
        asset_href: 
          source: node_stac_xs/asset_href
        bbox: bbox

      out:
      - tifs
        
      scatter: asset_href
      scatterMethod: dotproduct

    node_subset_p:

      run: translate.cwl  

      in: 
        asset_href: 
          source: node_stac_pan/asset_href
        bbox: bbox

      out:
      - tifs
        
    node_concatenate:
    
      run: concatenate.cwl

      in:
        tifs: 
          source: [node_subset_xs/tifs]
      
      out:
      - xs_stack

    node_bundle_to_perfect:

      run: bundle_to_perfect.cwl

      in:
        xs:
          source: [node_concatenate/xs_stack]
        pan:
          source: [node_subset_p/tifs]
      
      out:
      - pan-sharpened

cwlVersion: v1.0