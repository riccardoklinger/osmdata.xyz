![osmdata.xyz logo](https://github.com/michaelmgis/osmdata.xyz/blob/master/logos/osmdata_logo_power_wide_300dpi.png)

# osmdata.xyz | global osm extracts
This project deals with extracting all primary features regarding the OpenStreetMap project and their related tags. The data sets are provided as Geopackage.

## Extracts are available on
https://download.osmdata.xyz/

In a monthly cycle new extracts are provided. The first Planet Dump of each month from openstreetmap.org will be available 10 days later as it takes a while for the data to be processed. Every second month, Buildings and Highways will be updated.

Projection of the geodata: WGS 84 | EPSG 4326 | https://spatialreference.org/ref/epsg/4326/

## Why
OpenStreetMap (OSM) offers an amazing collection of data. The information contained provides many possibilities to better understand the whole world, e.g. with the use of a geographic information system (GIS). There are many tools to create small extracts from the OSM data: overpass-turbo (API) or other tools in QGIS/ArcGIS. A bigger challenge is the creation of ready to use GIS-compatible data sets from OSM, which cover whole countries, continents or even the whole world.

This project is intended to provide the OpenStreetMap data for the whole world directly usable in a GIS. The data extracts are based on the primary map features. Each extract represents a key value (e.g. building or highway), whereby all prepared tags are always contained in the same way (see. mapping.yml). This way you can also discover interesting findings.

osmdata.xyz is my hobby and absolutely non-commercial. I'm happy to share open data, knowledge and insights.

## Utilized tools to create extracts
- imposm3 --> https://github.com/omniscale/imposm3 (see Version 2 since 20190805)
- PostGIS / PostgreSQL --> https://postgis.net/
- osmium --> https://osmcode.org/osmium-tool/
- gdal / ogr2ogr --> https://gdal.org/programs/ogr2ogr.html

- osm2pgsql --> https://wiki.openstreetmap.org/wiki/Osm2pgsql (used in Version 1)

## Data basis
- primary (map) features? --> https://wiki.openstreetmap.org/wiki/Map_Features
- planet file as osm.pbf --> https://planet.openstreetmap.org/

## Recent improvements and changes

- 10.2019
  - definition of geometrytype improve reading the content of a GeoPackage with QGIS
  - new tags: internet_access, wifi
- 08.2019
  - all geometries of each map feature are stored in one GeoPackage
  - new processing chain - imposm3 is used since the extracts from 20190805 - see Version 2.

## Statistics and explanation of the approach
The processing chain published here is designed to reduce storage consumption as much as possible. Each extract based on the primary map feature (e.g. building) is created individually. Intermediate products are deleted to save storage space.

**Example: "building" as extract with the highest storage usage**: A maximum of 608 GB of storage space is required to create the largest data set "building". All other primary map features require significantly less storage. 

|Type|Size|
| ------------- | ------------- |
|all PBF files|50,00 GB|
|impcache|33,50 GB|
|PostGIS database|234,40 GB|
|Building GPKG|290,00 GB|
|**Sum**|**607,90 GB**|

**Example: entire global data set is stored in a database - extract of buildings**: A maximum of 924 GB of storage is required to create the largest data set "building".

|Type|Size|
| ------------- | ------------- |
|PBF|47,00 GB|
|impcache|92,00 GB|
|PostGIS database|495,00 GB|
|Building GPKG|290,00 GB|
|**Sum**|**924,00 GB**|

**Conclusion**: If storage space plays a role, then the approach published here is recommended. If there is enough memory, you can skip the step of splitting the PBF files (03_osm_filter) and just transfer everything to the database.

## Copyright and License 
OpenStreetMap© is open data, licensed under the Open Data Commons Open Database License (ODbL) by the OpenStreetMap Foundation (OSMF). 
https://www.openstreetmap.org/copyright/en

## Happy about feedback
Let me know, if you are happy or what could be improved.
Please post an issue or write to hello@osmdata.xyz
