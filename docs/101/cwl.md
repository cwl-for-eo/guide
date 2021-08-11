# CWL 101

The paper [_Methods Included: Standardizing Computational Reuse and Portability with the Common Workflow Language_](https://arxiv.org/abs/2105.07028) provides an excellent description of the Common Workflow Language project producing free and open standards for describing command-line
tool based workflows.

## TL;DR

Although the paper provides a clear and concise description of the CWL standards, here's a light summary wrapping up the main points to provide the required concepts behind this guide.

### CWL Key Insights

1. CWL is a set of standards for describing and sharing computational workflows.

2. The CWL standards are used daily in many science and engineering domains, including by multi-stakeholder teams.

3. The CWL standards use a declarative syntax, facilitating polylingual workflow tasks. By being explicit about the run-time environment and any use of software containers, the CWL standards enable portability and reuse. 

4. The CWL standards provide a separation of concerns between workflow authors and workflow platforms.

5. The CWL standards support critical workflow concepts like automation, scalability, abstraction, provenance, portability, and reusability. 

6. The CWL standards are developed around core principles of community and shared decision-making, re-use, and zero cost for participants.

7. The CWL standards are provided as freely available open standards, supported by a diverse community in collaboration with industry, and is a Free/Open Source Software ecosystem 

### CWL Features

The CWL standard support polylingual and multi-party workflows and includes two main components:

1. A standard for describing command line tools

2. A standard for describing workflows that compose such tool descriptions

The CWL standards define an explicit language with a textual syntax derived from YAML

#### CWL Command Line Tool Description Standard

The CWL Command Line Tool Description Standard describes:

- how a particular command line tool works: what are the
inputs and parameters and their types
- how to add the correct flags and switches to the command line invocation 
- where to find the output files

#### CWL Workflow Description Standard

The CWL Workflow Description Standard is based on the same textual syntax derived from YAML to explicit workflow level inputs, outputs and steps.

Steps are comprised of CWL CommandLineTools or CWL sub-workflows, each re-exposing their tool’s required inputs. 

Inputs for each step are connected by referencing the name of either the common workflow inputs or particular outputs of other steps.

The workflow outputs expose selected outputs from workflow steps.

Being CWL a set of standards, the workflows are executed using a CWL _runner_ and there are several implementations of such runners. 

This guide uses the CWL runner [cwltool](https://pypi.org/project/cwltool).

### Writting your first CWL CommandLineTool document

Goal: create a CWL *CommandLineTool* that uses GDAL's `gdal_translate` to clip a GeoTIFF using a given bounding box expressed in a defined EPSG code. 

Use a text editor to create a new plain text file and:

- set the CWL class `CommandLineTool`

```yaml hl_lines="1-1"
class: CommandLineTool


```

- set the CWL version in the last line

```yaml hl_lines="3-3"
class: CommandLineTool

cwlVersion: v1.0
```

* add the `CommandLineTool` elements:
    * `baseCommand`: the CLI utility to invoke
    * `arguments`: any arguments for the CLI utility
    * `inputs`: the input parameters to expose 
    * `outputs`: the outputs to collect after the execution of the CLI utility

```yaml hl_lines="3-9"
class: CommandLineTool

baseCommand:

arguments:

inputs:

outputs:

cwlVersion: v1.0
```

- add the `requirements` block to specify the CWL requirements used for running the CWL document

```yaml hl_lines="3-3"
class: CommandLineTool

requirements: 

baseCommand:

arguments:

inputs:

outputs:

cwlVersion: v1.0
```

It's now time to fill the elements with their values.

- add the `baseCommand`: 

```yaml hl_lines="5-5"
class: CommandLineTool

requirements: 

baseCommand: gdal_translate

arguments:

inputs:

outputs:

cwlVersion: v1.0
```

- set the container where `gdal_translate` is available:

```yaml hl_lines="4-5"
class: CommandLineTool

requirements: 
  DockerRequirement: 
    dockerPull: osgeo/gdal

baseCommand: gdal_translate

arguments:

inputs:

outputs:

cwlVersion: v1.0
```

- set the inputs:
    * `geotiff` of type `File` which is the path to the GeoTIFF file 
    * `bbox` of type `string` which is the bounding box expressed as `"xmin,ymin,latmin,latmax"`
    * `epsg` of type `string` which is the EPSG code of the bounding box coordinates

```yaml hl_lines="12-18"
class: CommandLineTool

requirements: 
  DockerRequirement: 
    dockerPull: osgeo/gdal

baseCommand: gdal_translate

arguments:

inputs:
  geotiff: 
    type: File
  bbox: 
    type: string
  epsg:
    type: string
    default: "EPSG:4326" 

outputs:

cwlVersion: v1.0
```

`gdal_translate` uses `-projwin ulx uly lrx lry` to set the area of interest. Since our bounding box is expressed as `xmin,ymin,latmin,latmax`, we'll have to manipulate the `bbox` value to format it as expected by `gdal_translate`. 
This is easily achieved by using the `InlineJavascriptRequirement` CWL requirement and using Javascript to manipulate the `bbox` input:

```yaml hl_lines="4-4"
class: CommandLineTool

requirements: 
  InlineJavascriptRequirement: {}
  DockerRequirement: 
    dockerPull: osgeo/gdal

baseCommand: gdal_translate

arguments:

inputs:
  geotiff: 
    type: File
  bbox: 
    type: string
  epsg:
    type: string
    default: "EPSG:4326" 

outputs:

cwlVersion: v1.0
```

and:

```yaml hl_lines="11-15"
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

inputs:
  geotiff: 
    type: File
  bbox: 
    type: string
  epsg:
    type: string
    default: "EPSG:4326" 

outputs:

cwlVersion: v1.0
```

Now, we need to set `gdal_translate` flag `-projwin_srs` and use the input `epsg` value. This can be done by setting the `inputBinding` element:


```yaml hl_lines="25-28"
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

inputs:
  geotiff: 
    type: File
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

cwlVersion: v1.0
```

The next step is to add the input file (the `geotiff` input). Again we use the `inputBinding` and set the position. 

```yaml hl_lines="20-21"
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

cwlVersion: v1.0
```

Our last argument is the output file name. Since we haven't defined a parameter to set this value, we'll pass it in the `arguments` element and construct it based on the `geotiff` input parameter. We also have to tell where to put it.

```yaml hl_lines="16-17"
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

cwlVersion: v1.0
```

The file element is the `output` section. We'll call the result `clipped_tif` and set a search pattern to collect the output.

```yaml hl_lines="35-38"
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
```

Save it as `gdal-translate.cwl`

Validate it using `cwltool`:

```console
cwltool --validate gdal-translate.cwl
```

Now get the geotiff we'll use for testing our first CWL document:

```console
curl -o B04.tif https://sentinel-cogs.s3.us-west-2.amazonaws.com/sentinel-s2-l2a-cogs/53/H/PA/2021/7/S2B_53HPA_20210723_0_L2A/B04.tif
```

Create a file called `params.yml` with:

```yaml
bbox: "136.659,-35.96,136.923,-35.791"
geotiff: {"class": "File", "path": "B04.tif" }
epsg: "EPSG:4326"
```

Use `cwltool` to run the CWL document:

```console
cwltool gdal-translate.cwl params.yml
```

This will produce:

```console
INFO /srv/conda/bin/cwltool 3.1.20210628163208
INFO Resolved 'gdal-translate.cwl' to 'file:///home/fbrito/work/guide/gdal-translate.cwl'
INFO [job gdal-translate.cwl] /tmp/m68dfr9m$ docker \
    run \
    -i \
    --mount=type=bind,source=/tmp/m68dfr9m,target=/iWBQko \
    --mount=type=bind,source=/tmp/ku7m_krp,target=/tmp \
    --mount=type=bind,source=/home/fbrito/work/guide/B8A.tif,target=/var/lib/cwl/stg6d53b4c1-725d-4b0d-83dc-0d8662c928e7/B8A.tif,readonly \
    --workdir=/iWBQko \
    --read-only=true \
    --user=1000:1000 \
    --rm \
    --cidfile=/tmp/e5jclx6k/20210810091516-035626.cid \
    --env=TMPDIR=/tmp \
    --env=HOME=/iWBQko \
    osgeo/gdal \
    gdal_translate \
    -projwin \
    136.659 \
    -35.791 \
    136.923 \
    -35.96 \
    -projwin_srs \
    EPSG:4326 \
    /var/lib/cwl/stg6d53b4c1-725d-4b0d-83dc-0d8662c928e7/B8A.tif \
    B8A_clipped.tif
Input file size is 5490, 5490
0...10...20...30...40...50...60...70...80...90...100 - done.
INFO [job gdal-translate.cwl] Max memory used: 0MiB
INFO [job gdal-translate.cwl] completed success
{
    "clipped_tif": {
        "location": "file:///home/fbrito/work/guide/B8A_clipped.tif",
        "basename": "B8A_clipped.tif",
        "class": "File",
        "checksum": "sha1$033898bb305bb2ae53980182cd882b05cc585fa2",
        "size": 2256036,
        "path": "/home/fbrito/work/guide/B8A_clipped.tif"
    }
}
INFO Final process status is success
```

### Writting your first CWL Workflow document

Building on the `CommandLineTool` created on the previous step, the first `Workflow` will include two processing steps:

- a fan-out processing pattern to use `gdal_translate` to clip the bands B04, B03 and B02
- a fan-in processing pattern using OTB's image stacking CLI to create an RGB composite 

At this stage, there's a `translate.cwl` CWL document and a file `params.yml`.

Start creating the CWL workflow document with it's initial structure:

```yaml
class: 
label:  
doc:  
id: 

requirements:

inputs:
  
outputs:

steps:

  node_:
    
    run: 
        
    in:
      

    out:

cwlVersion: v1.0
```

Set the CWL class to `Workflow`:

```yaml hl_lines="1-1"
class: Workflow
label:  
doc:  
id: 

requirements:

inputs:
  
outputs:

steps:

  node_:
    
    run: 
        
    in:
      

    out:

cwlVersion: v1.0
```

Set the Workflow information (`label`, `doc`) and `id`:

```yaml hl_lines="2-4"
class: Workflow
label: Sentinel-2 RGB creation
doc:  This worflow creates an RGB composite
id: main

requirements:

inputs:
  
outputs:

steps:

  node_:
    
    run: 
        
    in:
      

    out:

cwlVersion: v1.0
```

Set the Workflow requirements to support the fan-out pattern. Setting the `ScatterFeatureRequirement` requirement tells the CWL runner to spwan several processes (these may run in parallel).

```yaml hl_lines="7-7"
class: Workflow
label: Sentinel-2 RGB creation
doc:  This worflow creates an RGB composite
id: main

requirements:
- class: ScatterFeatureRequirement

inputs:
  
outputs:

steps:

  node_:
    
    run: 
        
    in:
      

    out:

cwlVersion: v1.0
```
Define the inputs:
- the list of geotifs
- the area of interest
- the EPSG code used to express the area of interest coordinates

The `geotiffs` are a list of files, this workflow parameter type is now `File[]`:

```yaml hl_lines="11-22"
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

  aoi: 
    doc: area of interest as a bounding box
    type: string
  
  epsg:
    doc: EPSG code 
    type: string
    default: "EPSG:4326"

outputs:

steps:

  node_:
    
    run: 
        
    in:
      

    out:

cwlVersion: v1.0
```

Update the first processing step to set the sub-workflow `translate.cwl` to be run:

```yaml hl_lines="30-30"
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

  aoi: 
    doc: area of interest as a bounding box
    type: string
  
  epsg:
    doc: EPSG code 
    type: string
    default: "EPSG:4326"

outputs:

steps:

  node_:
    
    run: translate.cwl
        
    in:

    out:

cwlVersion: v1.0
```

Now, set the step inputs mapping where:

- `translate.cwl` input `geotiff` is mapped to worklow input `geotiffs`
- `translate.cwl` input `aoi` is mapped to worklow input `aoi`
- `translate.cwl` input `epsg` is mapped to worklow input `epsg`

```yaml hl_lines="34-36"
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

  aoi: 
    doc: area of interest as a bounding box
    type: string
  
  epsg:
    doc: EPSG code 
    type: string
    default: "EPSG:4326"

outputs:

steps:

  node_:
    
    run: translate.cwl
        
    in:
 
      geotiff: geotiffs  
      aoi: aoi
      epsg: epsg

    out:

cwlVersion: v1.0
```

Set the `node_translate` output, i.e. the `clipped_tif` generated by `translate.cwl`:

```yaml hl_lines="39-39"
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

  aoi: 
    doc: area of interest as a bounding box
    type: string
  
  epsg:
    doc: EPSG code 
    type: string
    default: "EPSG:4326"

outputs:

steps:

  node_translate:
    
    run: translate.cwl
        
    in:
 
      geotiff: geotiffs  
      aoi: aoi
      epsg: epsg

    out:
    - clipped_tif

cwlVersion: v1.0
```

Now set the fan-out configuration by setting the `scatter` method and input (the geotiffs):

```yaml hl_lines="41-42"
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

  aoi: 
    doc: area of interest as a bounding box
    type: string
  
  epsg:
    doc: EPSG code 
    type: string
    default: "EPSG:4326"

outputs:

steps:

  node_translate:
    
    run: translate.cwl
        
    in:
 
      geotiff: geotiffs  
      aoi: aoi
      epsg: epsg

    out:
    - clipped_tif

    scatter: geotiffs
    scatterMethod: dotproduct

cwlVersion: v1.0
```

The next step requires an additional CWL CommandLineTool. It's a file called `concatenate.cwl` and it contains:

```yaml
--8<--
101/concatenate.cwl
--8<--
```

Add the additional step to concatenate the clipped geotiffs.

```yaml hl_lines="44-53"
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

  aoi: 
    doc: area of interest as a bounding box
    type: string
  
  epsg:
    doc: EPSG code 
    type: string
    default: "EPSG:4326"

outputs:

steps:

  node_translate:
    
    run: translate.cwl
        
    in:
 
      geotiff: geotiffs  
      aoi: aoi
      epsg: epsg

    out:
    - clipped_tif

    scatter: geotiffs
    scatterMethod: dotproduct

  node_concatenate:

    run: concatenate.cwl

    in: 
      tifs:
        source: node_translate/clipped_tif

    out:
    - composite


cwlVersion: v1.0
```

The inputs come from the previous step using the mapping:

```yaml hl_lines="49-50"
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

  aoi: 
    doc: area of interest as a bounding box
    type: string
  
  epsg:
    doc: EPSG code 
    type: string
    default: "EPSG:4326"

outputs:

steps:

  node_translate:
    
    run: translate.cwl
        
    in:
 
      geotiff: geotiffs  
      aoi: aoi
      epsg: epsg

    out:
    - clipped_tif

    scatter: geotiffs
    scatterMethod: dotproduct

  node_concatenate:

    run: concatenate.cwl

    in: 
      tifs:
        source: node_translate/clipped_tif

    out:
    - composite


cwlVersion: v1.0
```

The workflow only misses the `Workflow` `output` block, a mapping to the `node_concatenate` outputs:

```yaml hl_lines="25-28"
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

  aoi: 
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
      aoi: aoi
      epsg: epsg

    out:
    - clipped_tif

    scatter: geotiffs
    scatterMethod: dotproduct

  node_concatenate:

    run: concatenate.cwl

    in: 
      tifs:
        source: node_translate/clipped_tif

    out:
    - composite


cwlVersion: v1.0
```

Download the three geotiff with:

```console
curl -o B04.tif https://sentinel-cogs.s3.us-west-2.amazonaws.com/sentinel-s2-l2a-cogs/53/H/PA/2021/7/S2B_53HPA_20210723_0_L2A/B04.tif
curl -o B03.tif https://sentinel-cogs.s3.us-west-2.amazonaws.com/sentinel-s2-l2a-cogs/53/H/PA/2021/7/S2B_53HPA_20210723_0_L2A/B03.tif
curl -o B02.tif https://sentinel-cogs.s3.us-west-2.amazonaws.com/sentinel-s2-l2a-cogs/53/H/PA/2021/7/S2B_53HPA_20210723_0_L2A/B02.tif
```

Create a file called `composite-params.yml` with:

```yaml
--8<--
composite-params.yml
--8<--
```

Run the workflow with:

```
cwltool --parallel composite.cwl composite-params.yml
```

This creates a file called `composite.tif`.

### Recomendations

- Include documentation and labels for all components to enable the automatic generation of helpful visual depictions for any given CWL description

- Include metadata about the tool  

- Include a _Workflow_ class for all CommandLineTools (a single step Workflow)

- Organize your CWL files is several individual files to ease their readability and maintenance. Pack your multi-file CWL Workflows (`cwltool --pack`) when needed

## References

- Crusoe, M. R. et al. _Methods Included: Standardizing Computational Reuse and Portability with the Common Workflow Language_, retrieved from https://arxiv.org/abs/2105.07028