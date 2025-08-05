#!/bin/bash

echo "Configuring static IPs for Kubernetes VMs..."

# Master node configuration (192.168.0.170 -> 192.168.0.240)
echo "Configuring master node (k8s-master)..."
ssh nox@192.168.0.170 "sudo tee /etc/netplan/01-netcfg.yaml > /dev/null" << 'EOF'
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

# Worker node configuration (192.168.0.213 -> 192.168.0.241)
echo "Configuring worker node (k8s-worker)..."
ssh nox@192.168.0.213 "sudo tee /etc/netplan/01-netcfg.yaml > /dev/null" << 'EOF'
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.0.241/24
      gateway4: 192.168.0.1
      nameservers:
          addresses: [8.8.8.8, 8.8.4.4]
EOF

echo "Applying network configuration on master..."
ssh nox@192.168.0.170 "sudo netplan apply"

echo "Applying network configuration on worker..."
ssh nox@192.168.0.213 "sudo netplan apply"

echo ""
echo "Static IP configuration complete!"
echo "Master: 192.168.0.240"
echo "Worker: 192.168.0.241"
echo ""
echo "Note: You may need to reconnect using the new IPs."
echo "Test connectivity with:"
echo "  ssh nox@192.168.0.240"
echo "  ssh nox@192.168.0.241" 