# PostgreSQL 9.1 on Ubuntu Trusty
#
# Included plugins:
# pgextwlist
FROM markusma/ubuntu:trusty

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
 && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7FCC7D46ACCC4CF8 \
 && apt-get update \
 && apt-get install -y --no-install-recommends postgresql-9.1 postgresql-contrib-9.1 postgresql-server-dev-all git build-essential language-pack-fi less \
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

RUN curl -L https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 -o /usr/local/bin/gosu \
 && chmod +x /usr/local/bin/gosu

COPY etc/ /etc/
COPY bin/ /usr/local/bin/

EXPOSE 5432
VOLUME ["/var/lib/postgresql/9.1/main"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/lib/postgresql/9.1/bin/postgres", "-D", "/var/lib/postgresql/9.1/main", "-c", "config_file=/etc/postgresql/9.1/main/postgresql.conf"]
