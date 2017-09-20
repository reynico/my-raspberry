#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage: $0 profile"
    exit 1
fi

cd /etc/openvpn/easy-rsa/
easyrsa build-client-full ${1} nopass

cat /etc/openvpn/client/client.conf \
    <(echo -e '<ca>') \
    /etc/openvpn/easy-rsa/pki/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    /etc/openvpn/easy-rsa/pki/issued/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    /etc/openvpn/easy-rsa/pki/private/${1}.key \
    <(echo -e '</key>\n<tls-auth>') \
    /etc/openvpn/easy-rsa/keys/ta.key \
    <(echo -e '</tls-auth>') \
    > /etc/openvpn/client/${1}.ovpn
