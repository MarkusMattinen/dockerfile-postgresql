#!/bin/bash

chown -R postgres:postgres /var/lib/postgresql/*/main /etc/postgresql/*/main
exec gosu postgres "$@"
