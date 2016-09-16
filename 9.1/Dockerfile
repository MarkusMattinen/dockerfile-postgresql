# PostgreSQL 9.1 and supervisord on Ubuntu Trusty
#
# Included plugins:
# pgextwlist
FROM markusma/supervisord:ubuntu-trusty

RUN rm -rf /etc/ssl/private

ENV POSTGRESQL_VERSION 9.1

RUN apt-get update \
 && apt-get install -y --no-install-recommends postgresql-${POSTGRESQL_VERSION} postgresql-contrib-${POSTGRESQL_VERSION} postgresql-server-dev-all git build-essential language-pack-fi less \
 && dpkg-reconfigure locales \
 && cd /tmp \
 && git clone https://github.com/dimitri/pgextwlist.git \
 && cd pgextwlist \
 && make \
 && make install \
 && mkdir -p `pg_config --pkglibdir`/plugins \
 && cp pgextwlist.so `pg_config --pkglibdir`/plugins \
 && cd / \
 && rm -rf /tmp/pgextwlist \
 && apt-get purge -y postgresql-server-dev-all git build-essential \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD config/etc/postgresql/${POSTGRESQL_VERSION}/main/pg_hba.conf /etc/postgresql/${POSTGRESQL_VERSION}/main/pg_hba.conf
ADD config/etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf /etc/postgresql/${POSTGRESQL_VERSION}/main/postgresql.conf
ADD config/etc/supervisor/conf.d/postgresql.conf /etc/supervisor/conf.d/postgresql.conf

EXPOSE 5432
