# postgresql and supervisord on trusty
#
# Included plugins:
# pgextwlist
FROM markusma/supervisord:trusty

RUN rm -rf /etc/ssl/private

ENV POSTGRESQL_VERSION 9.5
ENV POSTGIS_VERSION 2.2

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main ${POSTGRESQL_VERSION}" > /etc/apt/sources.list.d/pgdg.list \
 && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7FCC7D46ACCC4CF8 \
 && apt-get update \
 && apt-get install -y --no-install-recommends postgresql-${POSTGRESQL_VERSION} postgresql-contrib-${POSTGRESQL_VERSION} postgresql-${POSTGRESQL_VERSION}-postgis-${POSTGIS_VERSION} language-pack-fi \
postgresql-server-dev-${POSTGRESQL_VERSION} git build-essential \
 && dpkg-reconfigure locales \
 && mkdir -p /var/run/postgresql/${POSTGRESQL_VERSION}-main.pg_stat_tmp \
 && chown postgres:postgres /var/run/postgresql/${POSTGRESQL_VERSION}-main.pg_stat_tmp \
 && cd /tmp \
 && git clone https://github.com/dimitri/pgextwlist.git \
 && cd pgextwlist \
 && make \
 && make install \
 && mkdir -p `pg_config --pkglibdir`/plugins \
 && cp pgextwlist.so `pg_config --pkglibdir`/plugins \
 && cd /tmp \
 && apt-get autoremove --purge -y postgresql-server-dev-${POSTGRESQL_VERSION} git build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD config/etc/postgresql/${POSTGRESQL_VERSION}/main/pg_hba.conf /etc/postgresql/${POSTGRESQL_VERSION}/main/pg_hba.conf
ADD config/etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf /etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf
ADD config/etc/supervisor/conf.d/postgresql.conf /etc/supervisor/conf.d/postgresql.conf

EXPOSE 5432
