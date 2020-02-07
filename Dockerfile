FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

ARG FORTICLIENT_VERSION=4.4.2329-1
ENV FORTICLIENT_VERSION=$FORTICLIENT_VERSION

ARG FORTICLIENT_SHA256=d2f7a22f0e21fa11fda3a3609eac3582979b4348141120a6d8599a8ac9480dda
ENV FORTICLIENT_SHA256=$FORTICLIENT_SHA256

RUN set -x \
    && apt-get update \
    && apt-get install -y -o APT::Install-Recommends=false -o APT::Install-Suggests=false \
        ca-certificates \
        curl \
        expect \
        net-tools \
        iproute2 \
        ipppd \
        iptables \
    # Install fortivpn client unofficial .deb
    && curl -sfo forticlient-sslvpn_amd64.deb "https://hadler.me/files/forticlient-sslvpn_${FORTICLIENT_VERSION}_amd64.deb" \
    && if [ -n "$FORTICLIENT_SHA256" ]; then \
        echo "${FORTICLIENT_SHA256} forticlient-sslvpn_amd64.deb" | sha256sum -c \
    ; fi \
    && dpkg -x forticlient-sslvpn_amd64.deb /usr/share/forticlient \
    && rm forticlient-sslvpn_amd64.deb \
    # Run setup
    && /usr/share/forticlient/opt/forticlient-sslvpn/64bit/helper/setup.linux.sh 2 \
    # Cleanup
    && apt-get purge -y \
        curl \
    && apt-get autoremove --purge -y \
    && rm -rf /var/lib/apt/lists/*

# Copy runfiles
COPY forticlient /usr/bin/
COPY start.sh /

ENV VPNADDR \
    VPNUSER \
    VPNPASS

CMD [ "/start.sh" ]
