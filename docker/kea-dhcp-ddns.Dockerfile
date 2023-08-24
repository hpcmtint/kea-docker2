# SPDX-License-Identifier: MPL-2.0

# This Kea docker image provides the following functionality:
# - running Kea DHCPv6 service
# - running Kea control agent (exposes REST API over http)
# - open source hooks
# - possible to build with premium hooks

FROM alpine:3.17
LABEL org.opencontainers.image.authors="Kea Developers <kea-dev@lists.isc.org>"

# Add Kea packages from cloudsmith. Make sure the version matches that of the Alpine version.
# Also, install all the open source hooks. When updating, new instructions can
# be found at: https://cloudsmith.io/~isc/repos/kea-2-3/setup/#formats-alpine
ARG VERSION=2.3.8
ARG TOKEN
ARG PREMIUM

RUN cp /etc/apk/repositories /etc/apk/repositories_backup && \
    # Install curl
    apk update && apk add --no-cache curl && \
    # Setup Cloudsmith repo
    curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-3/rsa.67D22B06FDC8FD58.key' > /etc/apk/keys/kea-2-3@isc-67D22B06FDC8FD58.rsa.pub && \
    curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-3/config.alpine.txt?distro=alpine&codename=v3.17' >> /etc/apk/repositories && \
    apk update && \
    # Install main Kea packaegs
    apk add --no-cache isc-kea-dhcp-ddns~=${VERSION} isc-kea-ctrl-agent~=${VERSION} supervisor && \
    # Install ddns hook which is available both in subscribers and enterprise
    if [ -n "$TOKEN" ] &&  ([ "$PREMIUM" == "SUBSCRIBERS" ] || [ "$PREMIUM" == "ENTERPRISE" ]); then \
    curl -1sLf "https://dl.cloudsmith.io/${TOKEN}/isc/kea-2-3-prv/rsa.3ACDF039B17886F3.key" > /etc/apk/keys/kea-2-3-prv@isc-3ACDF039B17886F3.rsa.pub &&  \
    curl -1sLf "https://dl.cloudsmith.io/${TOKEN}/isc/kea-2-3-prv/config.alpine.txt?distro=alpine&codename=v3.17" >> /etc/apk/repositories && \
    apk add --no-cache \
        isc-kea-premium-gss-tsig~=${VERSION}; \
    fi && \
    # Revert Cloudsmith repositories
    mv /etc/apk/repositories_backup /etc/apk/repositories && \
    # Create directory for supervisor logs
    mkdir -p /var/log/supervisor

VOLUME ["/etc/supervisor/conf.d/"]

# 8000 ctrl agent
# 8001 HA MT
# 547 blq
EXPOSE 8000/tcp 53001/udp

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
HEALTHCHECK CMD [ "supervisorctl", "status" ]