#!/bin/sh
source ./.env
while getopts 'v:' OPTION; do
  case "$OPTION" in
    v)
      VERSION="$OPTARG"
      ;;
    ?)
      echo "script usage: ./build_images.sh [-v keaversion]" >&2
      echo "Provide kea version in X.Y.Z format or precise package name. For example: 2.3.8 or 2.3.8-r20230530063557" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

echo "Kea version selected $VERSION"
docker build --tag kea-dhcp4:${VERSION} --build-arg VERSION=${VERSION} - < ../docker/kea-dhcp4.Dockerfile
docker build --tag kea-dhcp6:${VERSION} --build-arg VERSION=${VERSION} - < ../docker/kea-dhcp6.Dockerfile
wget https://gitlab.isc.org/isc-projects/kea/raw/Kea-${VERSION:0:5}/src/share/database/scripts/pgsql/dhcpdb_create.pgsql -O ./initdb/dhcpdb_create.sql

tee "config/kea/subnets4.json" > /dev/null <<EOF
"subnet4": [
  {
  "subnet": "$SUBNET4",
  "pools": [
    {
      "pool": "$POOL4"
    }
  ],
  "interface": "eth0"
  }
]
EOF

tee "config/kea/subnets6.json" > /dev/null <<EOF
"subnet6": [
  {
  "subnet": "$SUBNET6",
  "pools": [
    {
      "pool": "$POOL6"
    }
  ],
  "interface": "eth0"
  }
]
EOF
