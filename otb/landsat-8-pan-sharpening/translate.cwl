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
- -projwin_srs
- valueFrom: ${ return inputs.epsg; }
- valueFrom: |
    ${ if (inputs.asset.startsWith("http")) {

         return "/vsicurl/" + inputs.asset; 
       
       } else { 
        
         return inputs.asset;

       } 
    }
- valueFrom: ${ return inputs.asset.split("/").slice(-1)[0].replace("TIF", "tif"); }

inputs: 
  asset: 
    type: string
  bbox: 
    type: string
  epsg:
    type: string
    default: "EPSG:4326" 

outputs:
  tifs:
    outputBinding:
      glob: '*.tif'
    type: File

stderr: stderr
stdout: stdout

cwlVersion: v1.0