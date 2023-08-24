#!/bin/sh

docker build --tag kea-dhcp4 --build-arg VERSION=2.3.8-r20230530063557 - < ../docker/kea-dhcp4.Dockerfile
wget https://gitlab.isc.org/isc-projects/kea/raw/Kea-2.3.8/src/share/database/scripts/pgsql/dhcpdb_create.pgsql -O ./initdb/dhcpdb_create.sql
