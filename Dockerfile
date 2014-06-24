# postgresql and supervisord on trusty
#
# Included plugins:
# pgextwlist
FROM markusma/supervisord:trusty

RUN rm -rf /etc/ssl/private

RUN apt-get update \
 && apt-get install -y --no-install-recommends postgresql-9.3 postgresql-contrib-9.3 postgresql-server-dev-all git build-essential language-pack-fi \
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

ADD config/etc/postgresql/9.3/main/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD config/etc/postgresql/9.3/main/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
ADD config/etc/supervisor/conf.d/postgresql.conf /etc/supervisor/conf.d/postgresql.conf

EXPOSE 5432
