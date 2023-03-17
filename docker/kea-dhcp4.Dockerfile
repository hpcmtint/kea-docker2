# SPDX-License-Identifier: MPL-2.0

# This Kea docker image provides the following functionality:
# - running Kea DHCPv4 service
# TODO: - running Kea control agent (exposes REST API over http)
# - open source hooks

FROM alpine:3.13
LABEL org.opencontainers.image.authors="Kea Developers <kea-dev@lists.isc.org>"

# Add Kea packages from cloudsmith. Make sure the version matches that of the Alpine version.
# Also, install all the open source hooks.
RUN apk update && apk add curl && \
curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-1/rsa.CC39698D5EDFF644.key' > /etc/apk/keys/kea-2-1@isc-CC39698D5EDFF644.rsa.pub && \
curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-1/config.alpine.txt?distro=alpine&codename=v3.13' >> /etc/apk/repositories && \
apk update && \
apk add isc-kea-dhcp4 isc-kea-ctrl-agent \
        isc-kea-hook-mysql-cb \
        isc-kea-hook-ha \
        isc-kea-hook-stat-cmds \
        isc-kea-hook-flex-option \
        isc-kea-hook-lease-cmds \
        isc-kea-hook-run-script

VOLUME ["/etc/kea", "/var/log"]

EXPOSE 8080/udp 68/tcp

CMD ["/usr/sbin/kea-dhcp4", "-c", "/etc/kea/kea-dhcp4.conf"]
