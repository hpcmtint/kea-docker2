# SPDX-License-Identifier: MPL-2.0

# This Kea docker image provides the following functionality:
# - running Kea DHCPv4 service
# TODO: - running Kea control agent (exposes REST API over http)
# - open source hooks

FROM alpine:3.17
LABEL org.opencontainers.image.authors="Kea Developers <kea-dev@lists.isc.org>"

# Add Kea packages from cloudsmith. Make sure the version matches that of the Alpine version.
# Also, install all the open source hooks. When updating, new instructions can
# be found at: https://cloudsmith.io/~isc/repos/kea-2-3/setup/#formats-alpine
RUN apk update && apk add curl && \
curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-3/rsa.67D22B06FDC8FD58.key' > /etc/apk/keys/kea-2-3@isc-67D22B06FDC8FD58.rsa.pub && \
curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-3/config.alpine.txt?distro=alpine&codename=v3.15' >> /etc/apk/repositories && \
apk update && \
apk add isc-kea-dhcp4 isc-kea-ctrl-agent isc-kea-hooks

VOLUME ["/etc/kea", "/var/log"]

EXPOSE 8080/udp 68/tcp

CMD ["/usr/sbin/kea-dhcp4", "-c", "/etc/kea/kea-dhcp4.conf"]
