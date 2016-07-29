# forticlient

Connect to a FortiNet VPNs through docker

## Usage

The container uses the forticlientsslvpn_cli linux binary to manage ppp interface


All of the container traffic is routed through the VPN, so you can route host traffic through the container to access remote subnets.


```bash
# Create a docker network, to be able to control addresses
docker network create --subnet=172.20.0.0/16 fortinet

# Start the priviledged docker container with a static ip
docker run -it --rm \
  -privileged \
  --net fortinet --ip 172.20.0.2 \
  -e VPNADDR=host:port \
  -e VPNUSER=me@domain \
  -e VPNPASS=secret
  --name forticlient
  auchandirect/forticlient

# Add route for you remote subnet (ex. 10.0.8.0/24)
ip route add 10.0.8.0/24 via 172.20.0.2

# Access remote host from the subnet
ssh 10.0.8.1
```

If you don't want to create a docker network, you can find out the container ip once it is started with:
```bash
# Find out the container IP
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <container>
```

### Precompiled binaries

Thanks to [https://hadler.me](https://hadler.me/linux/forticlient-sslvpn-deb-packages/) for hosting up to date precompiled binaries which are used in this Dockerfile.