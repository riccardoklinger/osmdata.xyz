# osmdata.xyz | global osm extracts
This project deals with extracting all primary features regarding the openstreetmap project and their related tags to geopackage.

## Extracts are available on
https://download.osmdata.xyz/

Every two months, new extracts will be provided. 

Why not every month or in a higher frequency? - A full extract takes almost two weeks and requires high resources of CPU, RAM and SSD memory. Since it can't be delivered faster and costs money at the same time, I chose a two-month cycle. 

## Why
OpenStreetMap (OSM) offers an amazing collection of data. The information contained provides many possibilities to better understand the whole world, e.g. with the use of a geographic information system (GIS). There are many tools to create small extracts from the OSM data: overpass-turbo (API) or other tools in QGIS/ArcGIS. A bigger challenge is the creation of GIS-compatible data sets from OSM, which cover whole countries, continents or even the whole world.

This project is intended to provide the OpenStreetMap data for the whole world directly usable in a GIS. The data extracts are based on the primary map features. Each excerpt represents a key value, whereby all tags are always contained in the same way. This way you can also discover entries that may be untypical.

This project is my hobby and absolutely non-commercial. I'm happy to share open data, knowledge and insights.

## Utilized tools to create extracts
- osm2pgsql --> https://wiki.openstreetmap.org/wiki/Osm2pgsql
- PostGIS / PostgreSQL --> https://postgis.net/
- osmium --> https://osmcode.org/osmium-tool/
- gdal / ogr2ogr --> https://gdal.org/programs/ogr2ogr.html

## Data basis
- primary (map) features? --> https://wiki.openstreetmap.org/wiki/Map_Features
- planet file as osm.pbf --> https://planet.openstreetmap.org/

## Copyright and License 
OpenStreetMap© is open data, licensed under the Open Data Commons Open Database License (ODbL) by the OpenStreetMap Foundation (OSMF). 
https://www.openstreetmap.org/copyright/en

## Happy about feedback
Let me know, if you are happy or what could be improved.
