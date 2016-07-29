#!/bin/sh

if [ -z "$VPNADDR" -o -z "$VPNUSER" -o -z "$VPNPASS" ]; then
  echo "Variables VPNADDR, VPNUSER and VPNPASS must be set."; exit;
fi

# Setup masquerade, to allow using the container as a gateway
eth0_net=$(ip a | grep eth0 | grep inet | awk '{print $2}')
iptables -t nat -A POSTROUTING -s "$eth0_net" -j MASQUERADE

/usr/bin/forticlient

