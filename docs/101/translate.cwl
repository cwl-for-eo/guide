class: CommandLineTool

requirements: 
  InlineJavascriptRequirement: {}
  DockerRequirement: 
    dockerPull: osgeo/gdal

baseCommand: gdal_translate

arguments:
- -projwin 
- valueFrom: ${ return inputs.bbox.split(",")[0]; }
- valueFrom: ${ return inputs.bbox.split(",")[3]; }
- valueFrom: ${ return inputs.bbox.split(",")[2]; }
- valueFrom: ${ return inputs.bbox.split(",")[1]; }
- valueFrom: ${ return inputs.geotiff.basename.replace(".tif", "") + "_clipped.tif"; }
  position: 8

inputs:
  geotiff: 
    type: File
    inputBinding:
      position: 7
  bbox: 
    type: string
  epsg:
    type: string
    default: "EPSG:4326" 
    inputBinding:
      position: 6
      prefix: -projwin_srs
      separate: true

outputs:
  clipped_tif:
    outputBinding:
      glob: '*_clipped.tif'
    type: File

cwlVersion: v1.0