#!/bin/bash
# Golden Image Creation Script for Flatcar + Docker + Kubernetes Prerequisites
# This script prepares a Flatcar Linux node for Kubernetes deployment
# Note: Flatcar uses container-based approach, not traditional package installation

set -e

echo "=== Flatcar Linux Golden Image Setup ==="
echo "Setting up Docker and Kubernetes prerequisites..."

# 1. Configure and start Docker (already available in Flatcar)
echo "Configuring Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Add core user to docker group
sudo usermod -aG docker core

# Configure Docker daemon for Kubernetes
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart Docker with new configuration
sudo systemctl daemon-reload
sudo systemctl restart docker

# 2. Download and install Kubernetes binaries manually (Flatcar approach)
echo "Installing Kubernetes components..."
K8S_VERSION="v1.28.2"
DOWNLOAD_DIR="/opt/bin"
sudo mkdir -p $DOWNLOAD_DIR

# Download kubelet
curl -L "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubelet" -o /tmp/kubelet
sudo mv /tmp/kubelet $DOWNLOAD_DIR/kubelet
sudo chmod +x $DOWNLOAD_DIR/kubelet

# Download kubeadm
curl -L "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubeadm" -o /tmp/kubeadm
sudo mv /tmp/kubeadm $DOWNLOAD_DIR/kubeadm
sudo chmod +x $DOWNLOAD_DIR/kubeadm

# Download kubectl
curl -L "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl" -o /tmp/kubectl
sudo mv /tmp/kubectl $DOWNLOAD_DIR/kubectl
sudo chmod +x $DOWNLOAD_DIR/kubectl

# Ensure /opt/bin is in PATH
echo 'export PATH=$PATH:/opt/bin' | sudo tee -a /etc/profile

# 3. Install CNI plugins
echo "Installing CNI plugins..."
CNI_VERSION="v1.3.0"
sudo mkdir -p /opt/cni/bin
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz" | sudo tar -C /opt/cni/bin -xz

# 4. Configure kubelet systemd service
echo "Configuring kubelet service..."
sudo mkdir -p /etc/systemd/system/
sudo tee /etc/systemd/system/kubelet.service <<EOF
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/home/
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/opt/bin/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Create kubelet service drop-in directory
sudo mkdir -p /etc/systemd/system/kubelet.service.d
sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf <<EOF
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"
Environment="KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local"
Environment="KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt"
Environment="KUBELET_CADVISOR_ARGS=--cadvisor-port=0"
Environment="KUBELET_CERTIFICATE_ARGS=--rotate-certificates=true --cert-dir=/var/lib/kubelet/pki"
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --container-runtime-endpoint=unix:///var/run/dockershim.sock"
ExecStart=
ExecStart=/opt/bin/kubelet \$KUBELET_KUBECONFIG_ARGS \$KUBELET_CONFIG_ARGS \$KUBELET_SYSTEM_PODS_ARGS \$KUBELET_NETWORK_ARGS \$KUBELET_DNS_ARGS \$KUBELET_AUTHZ_ARGS \$KUBELET_CADVISOR_ARGS \$KUBELET_CERTIFICATE_ARGS \$KUBELET_EXTRA_ARGS
EOF

# Enable kubelet (but don't start yet - will start when joining cluster)
sudo systemctl daemon-reload
sudo systemctl enable kubelet

# 5. Configure networking prerequisites
echo "Configuring networking..."
sudo mkdir -p /etc/modules-load.d
sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl params required by setup, params persist across reboots
sudo mkdir -p /etc/sysctl.d
sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# 6. Disable swap (required for kubelet)
echo "Disabling swap..."
sudo swapoff -a

# 7. Create required directories
sudo mkdir -p /etc/kubernetes
sudo mkdir -p /var/lib/kubelet
sudo mkdir -p /etc/cni/net.d

# 8. Validation
echo "=== Validation ==="
echo "Docker version: $(docker --version)"
echo "Docker status: $(systemctl is-active docker)"
/opt/bin/kubelet --version
/opt/bin/kubeadm version
/opt/bin/kubectl version --client

echo "=== Golden Image Setup Complete ==="
echo "Ready to package as golden image!"
echo ""
echo "To create the golden box:"
echo "1. Run: vagrant package --output flatcar-k8s-golden.box"
echo "2. Add box: vagrant box add flatcar-k8s-golden flatcar-k8s-golden.box"
echo "3. Update Vagrantfiles to use: config.vm.box = 'flatcar-k8s-golden'"
