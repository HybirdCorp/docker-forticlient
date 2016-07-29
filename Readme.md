# forticlient

Connect to a FortiGate VPN through docker

### Start a priviledged container

The container uses the forticlientsslvpn_cli linux binary to manage ppp interface

```bash
docker run -it --rm \
  -privileged \
  -e VPNADDR=host:port \
  -e VPNUSER=me@domain \
  -e VPNPASS=secret
  --name forticlient
  auchandirect/forticlient
```

### Use container as a gateway

All of the container traffic is routed through the VPN and has `masquerade` enabled, so you can route traffic through the container to access the remote subnet.

```bash
# Find out the container IP
docker inspect --format '{{ .NetworkSettings.IPAddress }}' forticlient

# Create a subnet route
ip route add <remote_subnet> via <container_ip>

# Access remote host
ssh 10.0.8.1
```