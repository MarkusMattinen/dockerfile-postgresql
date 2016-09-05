# postgresql and supervisord on trusty
#
# Included plugins:
# pgextwlist
FROM markusma/supervisord:trusty

RUN rm -rf /etc/ssl/private

ENV POSTGRESQL_VERSION 9.5
ENV POSTGIS_VERSION_MAJOR 2.2
ENV POSTGIS_VERSION 2.2.2

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main ${POSTGRESQL_VERSION}" > /etc/apt/sources.list.d/pgdg.list \
 && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7FCC7D46ACCC4CF8 \
 && apt-get update \
 && apt-get install -y --no-install-recommends postgresql-${POSTGRESQL_VERSION} postgresql-contrib-${POSTGRESQL_VERSION} language-pack-fi libproj0 libxml2 libgdal1h libboost-thread1.54.0 libboost-serialization1.54.0 libmpfr4 libgeotiff2 libgmp10 liblas2 libmpfr4 libopenscenegraph99 \
postgresql-server-dev-${POSTGRESQL_VERSION} autoconf build-essential cmake docbook-mathml docbook-xsl libboost-dev libboost-thread-dev libboost-filesystem-dev libboost-system-dev libboost-iostreams-dev libboost-program-options-dev libboost-timer-dev libcunit1-dev libgdal-dev libgeos++-dev libgeotiff-dev libgmp-dev libjson0-dev libjson-c-dev liblas-dev libmpfr-dev libopenscenegraph-dev libpq-dev libproj-dev libxml2-dev xsltproc \
 && dpkg-reconfigure locales \
 && mkdir -p /var/run/postgresql/${POSTGRESQL_VERSION}-main.pg_stat_tmp \
 && chown postgres:postgres /var/run/postgresql/${POSTGRESQL_VERSION}-main.pg_stat_tmp \
 && cd /tmp \
 && git clone https://github.com/dimitri/pgextwlist.git \
 && cd pgextwlist \
 && make -j`nproc` \
 && make install \
 && mkdir -p `pg_config --pkglibdir`/plugins \
 && cp pgextwlist.so `pg_config --pkglibdir`/plugins \
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
 && curl -L http://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz | tar xz \
 && cd postgis-${POSTGIS_VERSION} \
 && ./configure --with-sfcgal=/usr/local/bin/sfcgal-config --with-geos=/usr/local/bin/geos-config \
 && make \
 && make install \
 && cd /tmp \
 && ldconfig \
 && apt-get autoremove --purge -y postgresql-server-dev-${POSTGRESQL_VERSION} autoconf build-essential cmake docbook-mathml docbook-xsl libboost-dev libboost-thread-dev libboost-filesystem-dev libboost-system-dev libboost-iostreams-dev libboost-program-options-dev libboost-timer-dev libcunit1-dev libgdal-dev libgeos++-dev libgeotiff-dev libgmp-dev libjson0-dev libjson-c-dev liblas-dev libmpfr-dev libopenscenegraph-dev libpq-dev libproj-dev libxml2-dev xsltproc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD config/etc/postgresql/${POSTGRESQL_VERSION}/main/pg_hba.conf /etc/postgresql/${POSTGRESQL_VERSION}/main/pg_hba.conf
ADD config/etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf /etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf
ADD config/etc/supervisor/conf.d/postgresql.conf /etc/supervisor/conf.d/postgresql.conf

EXPOSE 5432
