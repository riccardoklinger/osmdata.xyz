# use of an ubuntu base for simplicity and transparency

FROM ubuntu:18.04
MAINTAINER Riccardo Klinger <riccardo.klinger@gmail.com>

# getting postgres
RUN apt-get update && apt-get -y install wget gnupg2
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``12``.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install software-properties-common and PostgreSQL 12
#  and some other packages for ftp
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  software-properties-common \
  postgresql-12 \
  postgresql-client-12 \
  postgresql-contrib-12 \
  postgresql-12-postgis-3 \
  postgresql-12-postgis-3-scripts \
  aptitude  \
  unzip \
  openssh-client \
  openssh-server \
  sshpass \
  && aptitude update \
  && aptitude install -y nano axel wput screen p7zip-full osmium-tool \
  vnstat gdal-bin


WORKDIR /home/osmdata
RUN mkdir /home/osmdata/pbf
RUN mkdir /home/osmdata/gpkg
COPY ./import_osm.sh /home/osmdata/pbf
COPY ./mapping.yml /home/osmdata/pbf
RUN ["chown" , "-R", "postgres:postgres", "/home/osmdata"]
RUN ["chmod", "+x", "/home/osmdata/pbf/import_osm.sh"]


## download imposm3
RUN wget https://github.com/omniscale/imposm3/releases/download/v0.10.0/imposm-0.10.0-linux-x86-64.tar.gz -P /home/osmdata &&\
    tar -xf /home/osmdata/imposm-0.10.0-linux-x86-64.tar.gz &&\
    cp -R /home/osmdata/imposm-0.10.0-linux-x86-64/* /home/osmdata/pbf/ &&\
    rm -R /home/osmdata/imposm-0.10.0-linux-x86-64

# Getting data and pushing to the database
RUN axel -n 3 -a -v https://download.geofabrik.de/europe/germany/bremen-latest.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/aerialway -o pbf/bremen-latest_aerialway.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/aeroway -o pbf/bremen-latest_aeroway.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/amenity -o pbf/bremen-latest_amenity.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/barrier -o pbf/bremen-latest_barrier.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/boundary -o pbf/bremen-latest_boundary.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/building -o pbf/bremen-latest_building.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/craft -o pbf/bremen-latest_craft.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/emergency -o pbf/bremen-latest_emergency.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/geological -o pbf/bremen-latest_geological.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/highway -o pbf/bremen-latest_highway.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/historic -o pbf/bremen-latest_historic.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/leisure -o pbf/bremen-latest_leisure.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/landuse -o pbf/bremen-latest_landuse.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/man_made -o pbf/bremen-latest_man_made.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/military -o pbf/bremen-latest_military.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/natural -o pbf/bremen-latest_natural.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/office -o pbf/bremen-latest_office.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/place -o pbf/bremen-latest_place.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/power -o pbf/bremen-latest_power.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/public_transport -o pbf/bremen-latest_public_transport.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/railway -o pbf/bremen-latest_railway.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/route -o pbf/bremen-latest_route.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/shop -o pbf/bremen-latest_shop.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/sport -o pbf/bremen-latest_sport.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/telecom -o pbf/bremen-latest_telecom.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/tourism -o pbf/bremen-latest_tourism.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/waterway -o pbf/bremen-latest_waterway.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/addr:* -o pbf/bremen-latest_addr.osm.pbf &&\
    osmium tags-filter bremen-latest.osm.pbf nwr/water -o pbf/bremen-latest_water.osm.pbf

#getting md5 file for timestamp
RUN wget https://download.geofabrik.de/europe/germany/bremen-latest.osm.pbf.md5

# switch USER
USER postgres

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/12/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/12/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Create a PostgreSQL role named ``osmdata`` with ``osmdata`` as the password and
# then create a database `osmdata` owned by the ``osmdata`` role and add
# the postgis extension

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER osmdata WITH SUPERUSER PASSWORD 'osmdata';" &&\
    createdb -O osmdata osmdata &&\
    psql -d osmdata --command "CREATE EXTENSION IF NOT EXISTS postgis;" &&\
    psql -d osmdata --command "CREATE EXTENSION IF NOT EXISTS postgis_topology;" &&\
    psql -d osmdata --command "CREATE EXTENSION hstore;" &&\
    psql -d osmdata --command "CREATE SCHEMA import;"


# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql", "/home/osmdata/gpkg"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/12/bin/postgres", "-D", "/var/lib/postgresql/12/main", "-c", "config_file=/etc/postgresql/12/main/postgresql.conf"]
