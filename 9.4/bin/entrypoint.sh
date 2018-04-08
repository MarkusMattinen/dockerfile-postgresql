#!/bin/bash

chown -R postgres:postgres /var/lib/postgresql/*/main /etc/postgresql/*/main /var/log/postgresql
exec gosu postgres "$@"
