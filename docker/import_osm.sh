#!/bin/bash

set -e

start=`date +%s`


export host=$(hostname -i) #need shorter name
export port=5432
export PGPASSWORD="osmdata"

user=$1
server=$2
pwd=$3
if [ $# -eq 3 ]
then
	echo "FTP arguments supplied, will copy files to $2!"
fi
if [ $# -eq 0 ]
then
	echo "no FTP arguments supplied"
fi

#getting file creation time:
timestamp=$(date +%s -r /home/osmdata/bremen-latest.osm.pbf.md5)
echo $timestamp

#array=( natural office )
array=( natural building highway landuse waterway boundary route \
	amenity place leisure water power barrier railway man_made shop \
	sport tourism public_transport historic emergency office aeroway \
	craft military aerialway geological telecom )
for i in "${array[@]}"; do
	echo "treating $i"
	/home/osmdata/pbf/imposm import \
					-mapping "/home/osmdata/pbf/mapping.yml" \
					-cachedir "/home/osmdata/pbf/impcache" \
					-overwritecache \
					-srid 4326 \
					-read "/home/osmdata/pbf/bremen-latest_$i.osm.pbf" \
					-write \
					-connection "postgis://osmdata:osmdata@$host:$port/osmdata" \

	echo "$i points"
	ogr2ogr \
		-f "GPKG" "/home/osmdata/gpkg/${i}_EPSG4326.gpkg" \
		-nln "${i}_EPSG4326_point" \
		-nlt POINT PG:"host=$host port=$port dbname=osmdata user=osmdata password=osmdata" \
		-sql "select * from import.osm_point where '$i' <> ''"
	echo "$i lines"
	ogr2ogr \
		-f "GPKG" "/home/osmdata/gpkg/${i}_EPSG4326.gpkg" \
		-nln "${i}_EPSG4326_line" \
		-nlt LINESTRING -update PG:"host=$host port=$port dbname=osmdata user=osmdata password=osmdata" \
		-sql "select * from import.osm_linestring where '$i' <> ''"
	echo "$i polygons"
	ogr2ogr \
		-f "GPKG" "/home/osmdata/gpkg/${i}_EPSG4326.gpkg" \
		-nln "${i}_EPSG4326_polygon" \
		-nlt POLYGON -update PG:"host=$host port=$port dbname=osmdata user=osmdata password=osmdata" \
		-sql "select * from import.osm_polygon where '$i' <> ''"
	echo "files: "
	echo "$(ls -l /home/osmdata/gpkg)"
	echo "dropping tables"
	psql -h $host -p $port -d osmdata -U osmdata --no-password <<-EOSQL
		DROP TABLE import.osm_linestring;
		DROP TABLE import.osm_polygon;
		DROP TABLE import.osm_point;
	EOSQL
	echo "tables dropped"
	if [ $# -eq 3 ]
  then
		sshpass -p ${pwd} scp -o StrictHostKeyChecking=no -P 22 "/home/osmdata/gpkg/${i}_EPSG4326.gpkg" ${user}@${server}:~
	fi

done
end=`date +%s`

runtime=$((end-start))
echo "$runtime"
