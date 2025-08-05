#!/bin/bash

echo "Configuring static IP for master node (k8s-master)..."

# Backup existing config
sudo cp /etc/netplan/01-netcfg.yaml /etc/netplan/01-netcfg.yaml.backup

# Create new netplan configuration
sudo tee /etc/netplan/01-netcfg.yaml > /dev/null << 'EOF'
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.0.240/24
      gateway4: 192.168.0.1
      nameservers:
          addresses: [8.8.8.8, 8.8.4.4]
EOF

echo "Applying network configuration..."
sudo netplan apply

echo "Configuration complete!"
echo "New IP: 192.168.0.240"
echo "You may need to reconnect using the new IP." 