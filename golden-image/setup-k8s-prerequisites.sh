#!/bin/bash
# Flatcar Kubernetes Golden# Download and install Kubernetes binaries
log "Installing Kubernetes binaries..."
K8S_VERSION="v1.33.3"
CNI_VERSION="v1.3.0"ge Setup
# This script configures a Flatcar Linux VM for Kubernetes

set -e

echo "=== Configuring Flatcar for Kubernetes ==="

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting Kubernetes prerequisites setup..."

# 1. Configure Docker
log "Configuring Docker daemon..."
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "iptables": false
}
EOF

# Restart Docker with new configuration
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

# Add core user to docker group (if not already added)
sudo usermod -aG docker core

# 2. Download and install Kubernetes binaries
log "Installing Kubernetes binaries..."
K8S_VERSION="v1.28.2"
CNI_VERSION="v1.3.0"

# Create directories
sudo mkdir -p /opt/bin
sudo mkdir -p /opt/cni/bin

# Download Kubernetes binaries to /opt/bin
log "Downloading kubelet..."
sudo curl -L --fail --retry 3 "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubelet" -o /opt/bin/kubelet
sudo chmod +x /opt/bin/kubelet

log "Downloading kubeadm..."
sudo curl -L --fail --retry 3 "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubeadm" -o /opt/bin/kubeadm
sudo chmod +x /opt/bin/kubeadm

log "Downloading kubectl..."
sudo curl -L --fail --retry 3 "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl" -o /opt/bin/kubectl
sudo chmod +x /opt/bin/kubectl

# Download CNI plugins
log "Installing CNI plugins..."
sudo curl -L --fail --retry 3 "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz" | sudo tar -C /opt/cni/bin -xz

# Ensure /opt/bin is in PATH for all users
echo 'export PATH=$PATH:/opt/bin' | sudo tee -a /etc/profile

# 3. Configure kernel modules for Kubernetes networking
log "Configuring kernel modules..."
sudo mkdir -p /etc/modules-load.d
sudo tee /etc/modules-load.d/k8s.conf > /dev/null <<EOF
overlay
br_netfilter
EOF

# Load modules immediately
sudo modprobe overlay
sudo modprobe br_netfilter

# 4. Configure sysctl parameters for Kubernetes
log "Configuring sysctl parameters..."
sudo mkdir -p /etc/sysctl.d
sudo tee /etc/sysctl.d/k8s.conf > /dev/null <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params immediately
sudo sysctl --system

# 5. Create kubelet systemd service
log "Creating kubelet systemd service..."
sudo mkdir -p /etc/systemd/system/
sudo tee /etc/systemd/system/kubelet.service > /dev/null <<EOF
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

# Create kubelet service drop-in configuration
sudo mkdir -p /etc/systemd/system/kubelet.service.d
sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf > /dev/null <<EOF
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"
Environment="KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local"
Environment="KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt"
Environment="KUBELET_CADVISOR_ARGS=--cadvisor-port=0"
Environment="KUBELET_CERTIFICATE_ARGS=--rotate-certificates=true --cert-dir=/var/lib/kubelet/pki"
Environment="KUBELET_EXTRA_ARGS=--container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.9"
ExecStart=
ExecStart=/opt/bin/kubelet \$KUBELET_KUBECONFIG_ARGS \$KUBELET_CONFIG_ARGS \$KUBELET_SYSTEM_PODS_ARGS \$KUBELET_NETWORK_ARGS \$KUBELET_DNS_ARGS \$KUBELET_AUTHZ_ARGS \$KUBELET_CADVISOR_ARGS \$KUBELET_CERTIFICATE_ARGS \$KUBELET_EXTRA_ARGS
EOF

# 6. Create required directories
log "Creating Kubernetes directories..."
sudo mkdir -p /etc/kubernetes/pki
sudo mkdir -p /etc/kubernetes/manifests
sudo mkdir -p /var/lib/kubelet/pki
sudo mkdir -p /etc/cni/net.d

# 7. Enable kubelet service (but don't start - will start during cluster initialization)
sudo systemctl daemon-reload
sudo systemctl enable kubelet

# 8. Disable swap permanently
log "Disabling swap..."
sudo swapoff -a

# 9. Configure containerd (Flatcar uses containerd, not Docker runtime)
log "Configuring containerd for Kubernetes..."
sudo systemctl enable containerd
sudo systemctl start containerd

# 10. Validation
log "=== Validation ==="
echo "Docker version: $(docker --version || echo 'Docker not found')"
echo "Containerd status: $(systemctl is-active containerd || echo 'inactive')"
echo "Docker status: $(systemctl is-active docker || echo 'inactive')"

# Test Kubernetes binaries
if [ -f /opt/bin/kubelet ]; then
    echo "Kubelet version: $(/opt/bin/kubelet --version)"
else
    echo "ERROR: kubelet not found"
fi

if [ -f /opt/bin/kubeadm ]; then
    echo "Kubeadm version: $(/opt/bin/kubeadm version --short)"
else
    echo "ERROR: kubeadm not found"
fi

if [ -f /opt/bin/kubectl ]; then
    echo "Kubectl version: $(/opt/bin/kubectl version --client --short 2>/dev/null || /opt/bin/kubectl version --client)"
else
    echo "ERROR: kubectl not found"
fi

# Test network configuration
echo "Network bridge module: $(lsmod | grep br_netfilter || echo 'not loaded')"
echo "Overlay module: $(lsmod | grep overlay || echo 'not loaded')"

log "=== Flatcar Kubernetes Setup Complete ==="
log "Node is ready for Kubernetes cluster initialization or joining"

echo ""
echo "Next steps:"
echo "1. For master node: kubeadm init --pod-network-cidr=10.244.0.0/16"
echo "2. For worker nodes: kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash <hash>"
echo "3. Install CNI plugin (e.g., Flannel): kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml"
