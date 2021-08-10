# CWL guide for Earth Observation

This is a guide for learning how to use the Common Workflow Language in the Earth Observation domain.

This guide provides a light introduction to:

- The **Common Workflow Language**, an open standard for describing command-line tool based workflows 
- **Containers** as these provide a self-contained environment to run tools (e.g. GDAL, SNAP or OTB)
- **YAML** (**Y**AML **A**in't **M**arkup **L**anguage) a human-readable data-serialization language used to create CWL documents and their parameters file
- **SpatioTemporal Asset Catalog (STAC) (STAC)** as a specification to abstract the EO acquisition's files (data or metadata) and ease the access to bands or manifests

This guide includes a set of examples showing what can CWL do in typical Earth Observation use cases.

Finally this guide shows how to create OGC Application Packages using CWL and STAC according to the Best Practices for Earth Observation Application Packages. An Application Package can then be deployed on an Exploitation Platform and be exploited as a OGC API Processes service.
