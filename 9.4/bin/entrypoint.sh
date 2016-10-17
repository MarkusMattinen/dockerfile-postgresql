#!/bin/bash

chown -R postgres:postgres /var/lib/postgresql/*/main
exec gosu postgres "$@"
