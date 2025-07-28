#!/bin/bash
# Create local binary repository for faster, more reliable downloads

set -e

REPO_DIR="/home/jknoc/Development/jims-k8s-home-lab/local-repo"
K8S_VERSION="v1.28.2"
CNI_VERSION="v1.3.0"

echo "Creating local Kubernetes binary repository..."

mkdir -p "$REPO_DIR/kubernetes/$K8S_VERSION"
mkdir -p "$REPO_DIR/cni/$CNI_VERSION"

# Download binaries once to local repo
echo "Downloading Kubernetes binaries to local repo..."
curl -L "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubelet" -o "$REPO_DIR/kubernetes/$K8S_VERSION/kubelet"
curl -L "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubeadm" -o "$REPO_DIR/kubernetes/$K8S_VERSION/kubeadm"
curl -L "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl" -o "$REPO_DIR/kubernetes/$K8S_VERSION/kubectl"

echo "Downloading CNI plugins to local repo..."
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz" -o "$REPO_DIR/cni/$CNI_VERSION/cni-plugins.tgz"

# Create checksums for verification
cd "$REPO_DIR"
find . -type f -exec sha256sum {} \; > checksums.txt

echo "Local repository created at: $REPO_DIR"
echo "Start HTTP server: cd $REPO_DIR && python3 -m http.server 8080"
