#!/bin/bash

[ "$DEBUG" == "1" ] && set -x

VPN_PATH=/etc/openvpn
SSH_OPTS="-p 2222 -o ConnectTimeout=4 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

set -e

# Extract remote nodes
if [ "${VPN_SERVERS}" == "**ChangeMe**" ]; then
   echo "ERROR: You did not specify "-e VPN_SERVERS" environment variable - Exiting..."
   exit 1
fi
OVPN_SERVERS=`echo ${VPN_SERVERS} | sed "s/^/remote /g" | sed "s/,$//g" | sed "s/,/\nremote /g" | sed "s/:/ /g"`

if [ "${VPN_PASSWORD}" == "**ChangeMe**" ]; then
   echo "ERROR: You did not specify "-e VPN_PASSWORD" environment variable - Exiting..."
   exit 1
fi

rm -f $VPN_PATH/easy-rsa/keys/RancherVPNClient.ovpn
# Try to get OpenVPN config from any of listed servers
for SERVER in `echo ${VPN_SERVERS} | sed "s/,/ /g"`; do
    SERVER=`echo $SERVER | awk -F: '{print $1}'`
    if sshpass -p ${VPN_PASSWORD} ssh $SSH_OPTS root@$SERVER "get_vpn_client_conf.sh ${VPN_SERVERS}" > $VPN_PATH/RancherVPNClient.ovpn; then
       break
    else
       continue
    fi
done

# Enable tcp forwarding and add iptables MASQUERADE rule
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -F
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
