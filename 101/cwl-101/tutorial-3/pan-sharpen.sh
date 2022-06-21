#!/bin/bash

if [ "$#" -lt 2 ]
then
  echo "Usage: ..."
  exit 1
fi

# three parameters
stac_item="$1"
bbox="$2"
epsg="$3" 

# epsg default value
[ -z "${epsg}" ] && epsg="EPSG:4326"

# crop pan band
asset="B8"

# resolve pan asset href using curl to get the content of the STAC item and jq to parse it
asset_href=$( curl -s ${stac_item} | jq .assets.${asset}.href | tr -d '"' )

# check if it's a VSI
in_tif=$( [ ${asset_href} == http* ] && echo "/vsicurl/${asset_href}" || echo ${asset_href} ) 
# cropped tif reuses input name
pan=$( echo $asset_href | rev | cut -d "/" -f 1 | rev | sed 's/TIF/tif/' )

# use gdal_translate to crop the tif
gdal_translate \
    -projwin \
    $( echo ${bbox} | cut -d "," -f 1 ) \
    $( echo ${bbox} | cut -d "," -f 4 ) \
    $( echo ${bbox} | cut -d "," -f 3 ) \
    $( echo ${bbox} | cut -d "," -f 2 ) \
    -projwin_srs ${epsg} \
    ${in_tif} \
    ${pan}

# same approach for cropping the red, green and blue bands
cropped=()

for asset in "B4" "B3" "B2" 
do
    asset_href=$( curl -s ${stac_item} | jq .assets.${asset}.href | tr -d '"' )

    in_tif=$( [[ ${asset_href} == http* ]] && echo "/vsicurl/${asset_href}" || echo ${asset_href} ) 
    out_tif=$( echo $asset_href | rev | cut -d "/" -f 1 | rev | sed 's/TIF/tif/' )

    gdal_translate \
        -projwin \
        $( echo ${bbox} | cut -d "," -f 1 ) \
        $( echo ${bbox} | cut -d "," -f 4 ) \
        $( echo ${bbox} | cut -d "," -f 3 ) \
        $( echo ${bbox} | cut -d "," -f 2 ) \
        -projwin_srs ${epsg} \
        ${in_tif} \
        ${out_tif}

    cropped+=($out_tif)
done

xs=xs_stack.tif
# create a single tif with the red, green and blue cropped tifs
otbcli_ConcatenateImages \
    -out \
    ${xs} \
    -il $( for el in ${cropped[@]} ; do echo $el ; done )

# pansharpening
otbcli_BundleToPerfectSensor \
    -out pan-sharpen.tif \
    int \
    -inxs ${xs} \
    -inp ${pan}