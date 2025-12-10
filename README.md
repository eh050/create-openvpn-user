# OpenVPN Client Configuration Generator

A bash script that automates the creation of OpenVPN client configuration files with embedded certificates and keys.

## Overview

This script simplifies the process of generating OpenVPN client configuration files by automatically:
- Creating a properly formatted `.ovpn` file
- Embedding all required certificates and keys inline
- Configuring secure encryption settings
- Setting up connection parameters

## What It Does

The script generates a single-file OpenVPN client configuration that includes:
- **Connection settings**: Server IP, port, protocol (UDP)
- **Security configuration**: Modern cipher suites (AES-256-GCM, AES-128-GCM), SHA256 authentication
- **Embedded certificates**: CA certificate, client certificate, client private key, and TLS-auth key
- **Connection options**: Auto-reconnect, persistent connections, and proper routing

## Why It's Useful

1. **Time-saving**: Automates a manual, error-prone process that typically takes 10-15 minutes per client
2. **Consistency**: Ensures all client configurations follow the same security standards
3. **Single-file deployment**: Creates a portable `.ovpn` file that's easy to distribute
4. **Reduces errors**: Eliminates manual copy-paste mistakes when embedding certificates
5. **Security best practices**: Enforces modern encryption standards (AES-256-GCM, SHA256)

## Prerequisites

- OpenVPN server installed and configured
- Easy-RSA installed and initialized (typically at `~/easy-rsa`)
- Client certificate already generated using Easy-RSA
- TLS-auth key generated (typically at `/etc/openvpn/server/ta.key`)

## Configuration

Before using the script, edit these variables in the script:

```bash
SERVER_IP="YOUR_PUBLIC_IP"      # Your OpenVPN server's public IP or domain
SERVER_PORT="YOUR_SERVER_PORT"  # Your OpenVPN server port (default: 1194)
```

## Usage

1. Make the script executable:
   ```bash
   chmod +x create-openvpn-user.sh
   ```

2. Run the script with a client name:
   ```bash
   ./create-openvpn-user.sh clientname
   ```

3. The generated `.ovpn` file will be created in `~/openvpn-clients/`

## Example

```bash
./create-openvpn-user.sh john-doe
# Creates: ~/openvpn-clients/john-doe.ovpn
```

## File Structure

The script expects the following directory structure:
```
~/easy-rsa/
  └── pki/
      ├── ca.crt
      ├── issued/
      │   └── <clientname>.crt
      └── private/
          └── <clientname>.key

/etc/openvpn/server/
  └── ta.key
```

## Output

The script generates a single `.ovpn` file containing:
- Client configuration directives
- Inline CA certificate
- Inline client certificate
- Inline client private key
- Inline TLS-auth key

This file can be directly imported into OpenVPN clients on any platform.

## Security Features

- **Modern ciphers**: AES-256-GCM (preferred), with fallback options
- **Strong authentication**: SHA256 hashing
- **TLS authentication**: Additional security layer with static key
- **Compression disabled**: Prevents CRIME/BREACH vulnerabilities

## Troubleshooting

- **"No such file or directory"**: Ensure Easy-RSA is initialized and client certificates are generated
- **"Permission denied"**: Check that you have read access to certificate files and write access to the output directory
- **Connection issues**: Verify `SERVER_IP` and `SERVER_PORT` match your OpenVPN server configuration

## Notes

- The script assumes standard Easy-RSA directory structure
- Client certificates must be generated before running this script
- The output directory (`~/openvpn-clients`) will be created automatically if it doesn't exist (by the `cat` command)
