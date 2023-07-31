# SPDX-License-Identifier: MPL-2.0

FROM alpine:3.15
LABEL org.opencontainers.image.authors="Kea Developers <kea-dev@lists.isc.org>"

RUN apk update && \
    apk add curl && \
    curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-3/rsa.67D22B06FDC8FD58.key' > /etc/apk/keys/kea-2-3@isc-67D22B06FDC8FD58.rsa.pub && \
    curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-3/config.alpine.txt?distro=alpine&codename=v3.15' >> /etc/apk/repositories && \
    apk update && \
    apk add isc-kea-ctrl-agent

VOLUME ["/etc/kea", "/run/kea", "/var/log/kea"]

EXPOSE 8000/tcp

CMD ["/usr/sbin/kea-ctrl-agent", "-c", "/etc/kea/kea-ctrl-agent.conf"]
