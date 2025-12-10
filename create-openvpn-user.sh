#!/bin/bash
# ============================================================
# OpenVPN Client Configuration Generator
# Automates creation of .ovpn files with embedded certificates
# ============================================================

# Input validation
if [ -z "$1" ]; then
    echo "Usage: $0 <clientname>"
    exit 1
fi

# Configuration variables
CLIENT_NAME=$1
CLIENT_DIR=~/openvpn-clients
EASYRSA_DIR=~/easy-rsa
SERVER_IP="YOUR_PUBLIC_IP"  # Change this to your public IP or domain name
SERVER_PORT="YOUR_SERVER_PORT" # Change this to the port your OpenVPN server is running on

# Generate .ovpn file with embedded certificates
cat > ${CLIENT_DIR}/${CLIENT_NAME}.ovpn <<EOF
client
dev tun
proto udp
remote ${SERVER_IP} ${SERVER_PORT}
resolv-retry infinite
nobind
persist-key
persist-tun

# Security configuration
ca [inline]
cert [inline]
key [inline]
tls-auth [inline] 1
key-direction 1
data-ciphers AES-256-GCM:AES-128-GCM:AES-256-CBC:AES-128-CBC
data-ciphers-fallback AES-256-CBC
auth SHA256
allow-compression no
verb 3

# Embedded CA certificate
<ca>
$(cat ${EASYRSA_DIR}/pki/ca.crt)
</ca>

# Embedded client certificate
<cert>
$(cat ${EASYRSA_DIR}/pki/issued/${CLIENT_NAME}.crt)
</cert>

# Embedded client private key
<key>
$(cat ${EASYRSA_DIR}/pki/private/${CLIENT_NAME}.key)
</key>

# Embedded TLS-auth key
<tls-auth>
$(cat /etc/openvpn/server/ta.key)
</tls-auth>
EOF

echo "Client configuration created: ${CLIENT_DIR}/${CLIENT_NAME}.ovpn"

