#!/bin/bash

[ "$DEBUG" == "1" ] && set -x

prepare-vpn.sh

# Show information about needed route to be added to route traffic through VPN
local_docker_ip=`ip addr show dev eth0 | grep "inet " | head -1 | awk '{print $2}' | xargs -i ipcalc -n {} | grep Address | awk '{print $2}'`
echo "=========================================="
echo "In order to route your VPN traffic through this docker container, please execute the following command in your Docker host:"
echo "sudo route add -net 10.42.0.0/16 gw $local_docker_ip"
echo "=========================================="

/usr/bin/supervisord
