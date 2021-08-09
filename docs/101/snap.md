# SNAP 101

## Graph Processing Framework 

The SNAP architecture provides a flexible Graph Processing Framework (GPF) allowing the creation of processing graphs for batch processing
and customized processing chains.

A graph is a set of nodes connected by edges. In this case, the nodes are the processing steps called operators. The edges will show the direction in which the data is being passed between nodes; therefore it will be a directed graph. A graph can have no loops or cycles, so it will be a Directed Acyclic Graph (DAG).

The sources of the graph will be the data product readers, and the sinks can be either a product writer or an image displayed. An operator can
have one or more image sources and other parameters that define the operation. Two or more operators may be connected together so that the first operator becomes an image source to the next operator. By linking one operator to another, an imaging graph or processing chain can be created

The graph processor will not introduce any intermediate files unless a writer is optionally added anywhere in the sequence. 

Graphs offer the following advantages:
- no intermediate files written, no I/O overhead
- reusability of processing chains
- simple and comprehensive operator configuration
- reusability of operator configurations

SNAP EO Data Processors are implemented as GPF operators and can be invoked using the GPF Graph Processing Tool `gpt` which can be found in the bin directory of a SNAP installation.

The following command will dump the `gpt` print out a short description of what the tool is for and describes the arguments and options of
the tool. A list of available operators is displayed according to the toolboxes installed.

```console
docker run --rm docker.io/snap-gpt gpt -h
```

The partial output: 

```
Usage:
  gpt <op>|<graph-file> [options] [<source-file-1> <source-file-2> ...]

Description:
  This tool is used to execute SNAP raster data operators in batch-mode. The
  operators can be used stand-alone or combined as a directed acyclic graph
  (DAG). Processing graphs are represented using XML. More info about
  processing graphs, the operator API, and the graph XML format can be found
  in the SNAP documentation.

Arguments:
  <op>               Name of an operator. See below for the list of <op>s.
  <graph-file>       Operator graph file (XML format).
  <source-file-i>    The <i>th source product file. The actual number of source
                     file arguments is specified by <op>. May be optional for
                     operators which use the -S option.

Options:
  -h                 Displays command usage. If <op> is given, the specific
                     operator usage is displayed.
  -e                 Displays more detailed error messages. Displays a stack
                     trace, if an exception occurs.
  -t <file>          The target file. Default value is 'target.dim'.
  -f <format>        Output file format, e.g. 'GeoTIFF', 'HDF5',
                     'BEAM-DIMAP'. If not specified, format will be derived
                     from the target filename extension, if any, otherwise the
                     default format is 'BEAM-DIMAP'. Ony used, if the graph
                     in <graph-file> does not specify its own 'Write'
                     operator.
  -p <file>          A (Java Properties) file containing processing parameters
                     in the form <name>=<value> or a XML file containing a
                     parameter DOM for the operator. Entries in this file are
                     overwritten by the -P<name>=<value> command-line option
                     (see below). The following variables are substituted in
                     the parameters file:
                         ${system.<java-sys-property>}
                         ${operatorName} (given by the <op> argument)
                         ${graphFile} (given by the <graph-file> argument)
                         ${targetFile} (pull path given by the -t option)
                         ${targetDir} (derived from -t option)
                         ${targetName} (derived from -t option)
                         ${targetBaseName} (derived from -t option)
                         ${targetFormat} (given by the -f option)
  -c <cache-size>    Sets the tile cache size in bytes. Value can be suffixed
                     with 'K', 'M' and 'G'. Must be less than maximum
                     available heap space. If equal to or less than zero, tile
                     caching will be completely disabled. The default tile
                     cache size is '1,073,741,824M'.
  -q <parallelism>   Sets the maximum parallelism used for the computation,
                     i.e. the maximum number of parallel (native) threads.
                     The default parallelism is '16'.
  -x                 Clears the internal tile cache after writing a complete
                     row of tiles to the target product file. This option may
                     be useful if you run into memory problems.
  -S<source>=<file>  Defines a source product. <source> is specified by the
                     operator or the graph. In an XML graph, all occurrences of
                     ${<source>} will be replaced with references to a source
                     product located at <file>.
  -P<name>=<value>   Defines a processing parameter, <name> is specific for the
                     used operator or graph. In an XML graph, all occurrences
                     of ${<name>} will be replaced with <value>. Overwrites
                     parameter values specified by the '-p' option.
  -D<name>=<value>   Defines a system property for this invocation.
  -v <dir>           A directory containing any number of Velocity templates.
                     Each template generates a text output file along with the
                     target product. This feature has been added to support a
                     flexible generation of metadata files.
                     See http://velocity.apache.org/ and option -m.
  -m <file>          A (Java Properties) file containing (constant) metadata
                     in the form <name>=<value> or any XML file. Its primary 
                     usage is to provide an additional context to be used
                     from within the Velocity templates. See option -v.
  --diag             Displays version and diagnostic information.
Operators:
  Aatsr.SST                             Computes sea surface temperature (SST) from (A)ATSR products.
  AATSR.Ungrid                          Ungrids (A)ATSR L1B products and extracts geolocation and pixel field of view data.
  AdaptiveThresholding                  Detect ships using Constant False Alarm Rate detector.
  AddElevation                          Creates a DEM band
...
  Warp                                  Create Warp Function And Get Co-registrated Images
  WdviOp                                Weighted Difference Vegetation Index retrieves the Isovegetation lines parallel to soil line. Soil line has an arbitrary slope and passes through origin
  Wind-Field-Estimation                 Estimate wind speed and direction
  Write                                 Writes a data product to a file.
```

The `gpt` can process individual operators or a graph of connected operators.

Type:

```console
docker run --rm docker.io/snap-gpt gpt <operator-name> –h
```
 
to get usage information of an operator provided via `<operator-name>`. 

The usage text of an operator also displays an XML template clipping of the operators configuration when used in a graph.

Example:

```
docker run --rm docker.io/snap-gpt gpt Calibration –h
```

This outputs:

```console
Usage:
  gpt Calibration [options] 

Description:
  Calibration of products


Source Options:
  -Ssource=<file>    Sets source 'source' to <filepath>.
                     This is a mandatory source.

Parameter Options:
  -PauxFile=<string>                                    The auxiliary file
                                                        Value must be one of 'Latest Auxiliary File', 'Product Auxiliary File', 'External Auxiliary File'.
                                                        Default value is 'Latest Auxiliary File'.
  -PcreateBetaBand=<boolean>                            Create beta0 virtual band
                                                        Default value is 'false'.
  -PcreateGammaBand=<boolean>                           Create gamma0 virtual band
                                                        Default value is 'false'.
  -PexternalAuxFile=<file>                              The antenna elevation pattern gain auxiliary data file.
  -PoutputBetaBand=<boolean>                            Output beta0 band
                                                        Default value is 'false'.
  -PoutputGammaBand=<boolean>                           Output gamma0 band
                                                        Default value is 'false'.
  -PoutputImageInComplex=<boolean>                      Output image in complex
                                                        Default value is 'false'.
  -PoutputImageScaleInDb=<boolean>                      Output image scale
                                                        Default value is 'false'.
  -PoutputSigmaBand=<boolean>                           Output sigma0 band
                                                        Default value is 'true'.
  -PselectedPolarisations=<string,string,string,...>    The list of polarisations
  -PsourceBands=<string,string,string,...>              The list of source bands.

Graph XML Format:
  <graph id="someGraphId">
    <version>1.0</version>
    <node id="someNodeId">
      <operator>Calibration</operator>
      <sources>
        <source>${source}</source>
      </sources>
      <parameters>
        <sourceBands>string,string,string,...</sourceBands>
        <auxFile>string</auxFile>
        <externalAuxFile>file</externalAuxFile>
        <outputImageInComplex>boolean</outputImageInComplex>
        <outputImageScaleInDb>boolean</outputImageScaleInDb>
        <createGammaBand>boolean</createGammaBand>
        <createBetaBand>boolean</createBetaBand>
        <selectedPolarisations>string,string,string,...</selectedPolarisations>
        <outputSigmaBand>boolean</outputSigmaBand>
        <outputGammaBand>boolean</outputGammaBand>
        <outputBetaBand>boolean</outputBetaBand>
      </parameters>
    </node>
  </graph>
```

## Calling GPT with a Graph

Rather than calling each operator and specifying all its parameters, it is more convenient to pass the
required settings in an XML-encoded graph file.

To run gpt on a graph file type:

```console
gpt <GraphFile.xml> [options] [<source-file-1> <source-file-2> ...]
```

## Creating a Graph File

The basic format of a graph XML file is:

```xml
 <graph id="someGraphId">
 <version>1.0</version>
 <node id="someNodeId">
 <operator>OperatorName</operator>
 <sources>
<sourceProducts>${sourceProducts}</sourceProducts>
 </sources>
 <parameters>
 ....
 </parameters>
 </node>
 </graph>
 ```

Insert variables in the form `${variableName}` in place of a parameter value. `variableName` is then replaced with a value at the command line. 

For example, if a parameter for a file included the variable for `${myFilename}`

```xml
<parameters>
 <file>${myFilename}</file>
</parameters>
```

`gpt` is then invoked with:

```console
gpt mygraph.xml –PmyFilename=pathToMyFile
```

## Batch processing

SNAP users often resort to scripts to batch process their SNAP graphs. Below two examples of such scripts:

**For all envisat products in folder c:\ASAR run gpt Calibration and produce the output in the folder `c:\output`**

```console
for /r "c:\ASAR" %%X in (*.N1) do (gpt Calibration "%%X" -t "C:\output\%%~nX.dim")
```

**A set of input Sentinel-2 products shall be processed with the Resample processor.**

```bash
#!/bin/bash
# enable next line for debugging purpose
# set -x 

############################################
# User Configuration
############################################

# adapt this path to your needs
export PATH=~/progs/snap/bin:$PATH
gptPath="gpt"

############################################
# Command line handling
############################################

# first parameter is a path to the graph xml
graphXmlPath="$1"

# second parameter is a path to a parameter file
parameterFilePath="$2"

# use third parameter for path to source products
sourceDirectory="$3"

# use fourth parameter for path to target products
targetDirectory="$4"

# the fifth parameter is a file prefix for the target product name, typically indicating the type of processing
targetFilePrefix="$5"

   
############################################
# Helper functions
############################################
removeExtension() {
    file="$1"
    echo "$(echo "$file" | sed -r 's/\.[^\.]*$//')"
}


############################################
# Main processing
############################################

# Create the target directory
mkdir -p "${targetDirectory}"

# the d option limits the elemeents to loop over to directories. Remove it, if you want to use files.
for F in $(ls -1d "${sourceDirectory}"/S2*.SAFE); do
  sourceFile="$(realpath "$F")"
  targetFile="${targetDirectory}/${targetFilePrefix}_$(removeExtension "$(basename ${F})").dim"
  ${gptPath} ${graphXmlPath} -e -p ${parameterFilePath} -t ${targetFile} ${sourceFile}
done
```

While these are valid approaches, these scripts are not portable and hardly shareable.

Jump to <insert cross link> to learn how CWL can be used to process SNAP graphs.