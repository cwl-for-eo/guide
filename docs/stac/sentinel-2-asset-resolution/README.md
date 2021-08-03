# Sentinel-2 asset resolution 

This CWL document takes an URL to a Sentinel-2 STAC Item and resolves the asset key provided as input parameter.

It relies on `curl` and `jq` to get the STAC Item and parse its JSON content.