FROM ubuntu:18.04

ENV VPNADDR \
    VPNUSER \
    VPNPASS

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y -o APT::Install-Recommends=false -o APT::Install-Suggests=false \
  expect \
  net-tools \
  iproute2 \
  ipppd \
  iptables \
  && apt-get clean -q && apt-get autoremove --purge \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Install fortivpn client unofficial .deb
COPY forticlient-sslvpn_amd64.deb .
RUN dpkg -x forticlient-sslvpn_amd64.deb /usr/share/forticlient && rm forticlient-sslvpn_amd64.deb

# Run setup
RUN /usr/share/forticlient/opt/forticlient-sslvpn/64bit/helper/setup.linux.sh 2

# Copy runfiles
COPY forticlient /usr/bin/forticlient
COPY start.sh /start.sh

CMD [ "/start.sh" ]