# PostgreSQL 9.5 with PostGIS 2.2 on Ubuntu Bionic
#
# PostGIS compiled with geos 3.5
#
# Included plugins:
# pgextwlist
FROM markusma/ubuntu:bionic

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main 9.5" > /etc/apt/sources.list.d/pgdg.list \
 && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7FCC7D46ACCC4CF8 \
 && apt-get update \
 && apt-get install -y --no-install-recommends postgresql-9.5 postgresql-contrib-9.5 language-pack-fi libproj0 libxml2 libgdal1h libboost-thread1.54.0 libboost-serialization1.54.0 libmpfr4 libgeotiff2 libgmp10 liblas2 libmpfr4 libopenscenegraph99 \
postgresql-server-dev-9.5 autoconf build-essential cmake docbook-mathml docbook-xsl libboost-dev libboost-thread-dev libboost-filesystem-dev libboost-system-dev libboost-iostreams-dev libboost-program-options-dev libboost-timer-dev libcunit1-dev libgdal-dev libgeos++-dev libgeotiff-dev libgmp-dev libjson0-dev libjson-c-dev liblas-dev libmpfr-dev libopenscenegraph-dev libpq-dev libproj-dev libxml2-dev xsltproc \
 && dpkg-reconfigure locales \
 && mkdir -p /var/run/postgresql/9.5-main.pg_stat_tmp \
 && chown postgres:postgres /var/run/postgresql/9.5-main.pg_stat_tmp \
 && cd /tmp \
 && git clone https://github.com/dimitri/pgextwlist.git \
 && cd pgextwlist \
 && make -j`nproc` \
 && make install \
 && mkdir -p /usr/lib/postgresql/9.5/lib/plugins \
 && cp pgextwlist.so /usr/lib/postgresql/9.5/lib/plugins \
 && cd /tmp \
 && curl -L https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.8.1/CGAL-4.8.1.tar.xz | tar xJ \
 && cd CGAL-4.8.1 \
 && mkdir build && cd build \
 && cmake .. \
 && make -j`nproc` && make install \
 && cd /tmp \
 && git clone https://github.com/Oslandia/SFCGAL.git \
 && cd SFCGAL \
 && cmake . \
 && make -j`nproc` \
 && make install \
 && cd /tmp \
 && curl -L http://download.osgeo.org/geos/geos-3.5.0.tar.bz2 | tar xj \
 && cd geos-3.5.0 \
 && ./configure \
 && make \
 && make install \
 && cd /tmp \
 && curl -L http://download.osgeo.org/postgis/source/postgis-2.2.2.tar.gz | tar xz \
 && cd postgis-2.2.2 \
 && ./configure --with-sfcgal=/usr/local/bin/sfcgal-config --with-geos=/usr/local/bin/geos-config \
 && make \
 && make install \
 && cd /tmp \
 && ldconfig \
 && apt-get autoremove --purge -y postgresql-server-dev-9.5 autoconf build-essential cmake docbook-mathml docbook-xsl libboost-dev libboost-thread-dev libboost-filesystem-dev libboost-system-dev libboost-iostreams-dev libboost-program-options-dev libboost-timer-dev libcunit1-dev libgdal-dev libgeos++-dev libgeotiff-dev libgmp-dev libjson0-dev libjson-c-dev liblas-dev libmpfr-dev libopenscenegraph-dev libpq-dev libproj-dev libxml2-dev xsltproc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -L https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 -o /usr/local/bin/gosu \
 && chmod +x /usr/local/bin/gosu

COPY etc/ /etc/
COPY bin/ /usr/local/bin/

EXPOSE 5432
VOLUME ["/var/lib/postgresql/9.5/main"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/lib/postgresql/9.5/bin/postgres", "-D", "/var/lib/postgresql/9.5/main", "-c", "config_file=/etc/postgresql/9.5/main/postgresql.conf"]
