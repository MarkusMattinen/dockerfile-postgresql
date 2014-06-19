# postgresql on trusty
#
# Included plugins:
# pgextwlist
FROM markusma/base:trusty

RUN rm -rf /etc/ssl/private

RUN apt-get update \
 && apt-get install -y --no-install-recommends postgresql-9.3 postgresql-contrib-9.3 postgresql-server-dev-all git build-essential language-pack-fi \
 && dpkg-reconfigure locales \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp \
 && git clone https://github.com/dimitri/pgextwlist.git \
 && cd pgextwlist \
 && make \
 && make install \
 && mkdir -p `pg_config --pkglibdir`/plugins \
 && cp pgextwlist.so `pg_config --pkglibdir`/plugins

ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf

EXPOSE 5432

CMD ["su", "postgres", "sh", "-c", "/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf"]

