# osmdata.xyz | global osm extracts
This project deals with extracting all primary features regarding the openstreetmap project and their related tags to geopackage.

## Why
OpenStreetMap (OSM) offers an amazing collection of data. The information contained provides many possibilities to better understand the whole world, e.g. with the use of a geographic information system (GIS). There are many tools to create small extracts from the OSM data: overpass-turbo (API) or other tools in QGIS/ArcGIS. A bigger challenge is the creation of GIS-compatible data sets from OSM, which cover whole countries, continents or even the whole world.

This project is intended to provide the OpenStreetMap data for the whole world directly usable in a GIS. The data extracts are based on the primary map features. Each excerpt represents a key value, whereby all tags are always contained in the same way. This way you can also discover entries that may be untypical.

## Utilized tools to create extracts
- osm2pgsql
- PostGIS / PostgreSQL
- osmium
- gdal / ogr2ogr

## Data basis
- primary (map) features? --> https://wiki.openstreetmap.org/wiki/Map_Features
- planet file as osm.pbf --> https://planet.openstreetmap.org/
