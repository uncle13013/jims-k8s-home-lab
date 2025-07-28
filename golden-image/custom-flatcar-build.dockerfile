# Dockerfile-like approach for Flatcar
# This would use Flatcar's mantle tool to create custom images

# Base: Flatcar Container Linux
FROM quay.io/coreos/flatcar:stable

# Add Kubernetes binaries at build time
RUN mkdir -p /opt/bin /opt/cni/bin
RUN curl -L "https://dl.k8s.io/release/v1.28.2/bin/linux/amd64/kubelet" -o /opt/bin/kubelet
RUN curl -L "https://dl.k8s.io/release/v1.28.2/bin/linux/amd64/kubeadm" -o /opt/bin/kubeadm
RUN curl -L "https://dl.k8s.io/release/v1.28.2/bin/linux/amd64/kubectl" -o /opt/bin/kubectl
RUN curl -L "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz" | tar -C /opt/cni/bin -xz
RUN chmod +x /opt/bin/{kubelet,kubeadm,kubectl}

# This creates a custom .qcow2 or .vmdk image with everything pre-installed
