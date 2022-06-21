cwlVersion: v1.0

$graph:
- class: Workflow

  id: main

  requirements: 
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement

  inputs:
   
    red: 
      type: string
    green: 
      type: string
    blue: 
      type: string
    product:
      type: string[]

  outputs:

    preview: 
      outputSource: node_clip/preview
      type:
        type: array
        items:
          type: array
          items: File

  steps:
  
    node_clip:
    
      run: "#clipper"
    
      in:
        red: red
        green: green
        blue: blue
        product: product

      out:
      - preview
    
      scatter: product
      scatterMethod: dotproduct 

- class: Workflow

  id: clipper

  requirements: 
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement

  inputs:

    red: 
      type: string
    green: 
      type: string
    blue: 
      type: string
    product:
      type: string

  outputs:

    preview: 
      outputSource: node_gdal/preview
      type: File[]

  steps:

    node_gdal:

      in: 
        band: [red, green, blue]
        product: product
        
      out: 
      - preview

      run:
        "#gdal"

      scatter: band
      scatterMethod: dotproduct 


- class: CommandLineTool
  
  id: gdal

  requirements:
    InlineJavascriptRequirement: {}
    EnvVarRequirement:
      envDef:
        PROJ_LIB: /srv/conda/envs/notebook/share/proj
  hints:
    DockerRequirement: 
      dockerPull: docker.io/osgeo/gdal  
  baseCommand: gdal_translate

  arguments: 
  - -of
  - PNG
  - -ot 
  - Byte
  - -srcwin 
  - "1000"
  - "1000"
  - "500"
  - "500"
  - valueFrom: $( inputs.product + "/" + inputs.band + ".tif")
  - valueFrom: $(  inputs.product.split("/").slice(-1)[0] + "_" + inputs.band + ".png" )

  inputs:

    product: 
      type: string
    band:
      type: string

  outputs:

    preview: 
      type: File
      outputBinding:
        glob: "*.png"