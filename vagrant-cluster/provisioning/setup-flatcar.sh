#!/bin/bash
set -e

NODE_TYPE=$1
HOSTNAME=$(hostname)

echo "Setting up Flatcar Linux for Kubernetes ${NODE_TYPE} node: ${HOSTNAME}"

# Update system
sudo systemctl daemon-reload

# Create necessary directories
sudo mkdir -p /opt/bin
sudo mkdir -p /etc/kubernetes
sudo mkdir -p /var/lib/kubelet
sudo mkdir -p /etc/systemd/system/kubelet.service.d

# Download and install Kubernetes components
K8S_VERSION="v1.28.0"
ARCH="amd64"

echo "Downloading Kubernetes ${K8S_VERSION} components..."

# Download kubelet, kubeadm, kubectl
cd /tmp
curl -L --remote-name-all https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/${ARCH}/{kubeadm,kubelet,kubectl}

# Make them executable and move to /opt/bin
chmod +x {kubeadm,kubelet,kubectl}
sudo mv {kubeadm,kubelet,kubectl} /opt/bin/

# Create symlinks in /usr/bin for easier access
sudo ln -sf /opt/bin/kubeadm /usr/bin/kubeadm
sudo ln -sf /opt/bin/kubelet /usr/bin/kubelet  
sudo ln -sf /opt/bin/kubectl /usr/bin/kubectl

# Download and configure CNI plugins
CNI_VERSION="v1.3.0"
sudo mkdir -p /opt/cni/bin
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz" | sudo tar -C /opt/cni/bin -xz

# Configure containerd
sudo systemctl enable containerd
sudo systemctl start containerd

# Configure kubelet
sudo systemctl enable kubelet

# Apply cloud-init configuration
if [ -f /tmp/cloud-init.yml ]; then
    echo "Applying cloud-init configuration..."
    sudo coreos-cloudinit --from-file /tmp/cloud-init.yml
fi

# Enable IP forwarding and bridge-netfilter
echo 'net.bridge.bridge-nf-call-iptables = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Load bridge module
sudo modprobe br_netfilter

# Disable swap (if any)
sudo swapoff -a

# Create setup scripts based on node type
if [ "$NODE_TYPE" = "master" ]; then
    sudo tee /opt/bin/setup-kubernetes-master.sh << 'EOF'
#!/bin/bash
set -e

echo "Initializing Kubernetes master node..."

# Wait for containerd to be ready
while ! systemctl is-active --quiet containerd; do
    echo "Waiting for containerd to be ready..."
    sleep 5
done

# Initialize the cluster (only on the first master)
if [ "$(hostname)" = "master-1" ]; then
    echo "Initializing cluster on primary master..."
    kubeadm init --config=/etc/kubernetes/kubeadm-config.yaml --upload-certs
    
    # Set up kubectl for the core user
    mkdir -p /home/core/.kube
    cp -i /etc/kubernetes/admin.conf /home/core/.kube/config
    chown core:core /home/core/.kube/config
    
    # Install Calico CNI
    export KUBECONFIG=/etc/kubernetes/admin.conf
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
    
    echo "Master node setup complete!"
    echo "Join command will be saved to /tmp/kubeadm-join-command"
    kubeadm token create --print-join-command > /tmp/kubeadm-join-command
fi
EOF

else
    sudo tee /opt/bin/setup-kubernetes-worker.sh << 'EOF'
#!/bin/bash
set -e

echo "Setting up Kubernetes worker node..."

# Wait for containerd to be ready
while ! systemctl is-active --quiet containerd; do
    echo "Waiting for containerd to be ready..."
    sleep 5
done

echo "Worker node setup complete!"
echo "Ready to join cluster with: kubeadm join ..."
EOF

fi

# Make setup scripts executable
sudo chmod +x /opt/bin/setup-kubernetes-*.sh

echo "Flatcar Linux setup complete for ${NODE_TYPE} node: ${HOSTNAME}"
echo "Rebooting to apply all changes..."

# Reboot to ensure all changes take effect
sudo systemctl reboot
