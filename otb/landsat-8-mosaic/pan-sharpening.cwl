$graph:
- class: Workflow
  label: Landsat-8 pan-sharpening 
  doc: Landsat-8 pan-sharpening  
  id: main

  requirements:
  - class: ScatterFeatureRequirement

  inputs:
    stac_item: 
      doc: Landsat-8 item
      type: string
    xs_bands: 
      type: string[]
      default: ["B4", "B3", "B2"]
    p_band:
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
        asset: xs_bands

      out:
        - asset_href

      scatter: asset
      scatterMethod: dotproduct 
    
    node_stac_p:
    
      run: asset.cwl
        
      in:
        stac_item: stac_item
        asset: p_band

      out:
        - asset_href
            
    node_concatenate:
    
      run: concatenate.cwl

      in:
        tifs: 
          source: [node_stac_xs/asset_href]
      
      out:
      - xs_stack

    node_bundle_to_perfect:

      run: bundle_to_perfect.cwl

      in:
        xs:
          source: [node_concatenate/xs_stack]
        pan:
          source: [node_stac_p/asset_href]
      
      out:
      - pan-sharpened

cwlVersion: v1.0