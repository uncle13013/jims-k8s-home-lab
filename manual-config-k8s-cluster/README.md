# Manual Kubernetes Learning with Kind

A simple, modern approach to learning Kubernetes "the hard way" using Kind (Kubernetes in Docker).

## Why Kind?

- ✅ **Zero VM management** - No VirtualBox, Vagrant, or networking issues
- ✅ **Fast setup** - Cluster ready in seconds, not minutes
- ✅ **Industry standard** - Used by Kubernetes developers and CI/CD
- ✅ **Learning focused** - Focus on Kubernetes, not infrastructure
- ✅ **Cross-platform** - Works identically on Windows, Mac, Linux

## Quick Start

### 1. Install Prerequisites

**Docker Desktop:**
- Install Docker Desktop for Windows/Mac
- Or Docker Engine for Linux

**Kind:**
```bash
# Download and install Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

**Kubectl:**
```bash
# Download kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### 2. Create Cluster

```bash
# Create a single-node cluster
kind create cluster --name k8s-learning

# Verify it's working
kubectl cluster-info
kubectl get nodes
```

### 3. Start Learning

```bash
# Access your cluster
kubectl get pods --all-namespaces
kubectl get services --all-namespaces

# Explore the cluster
kubectl describe node kind-control-plane
```

## Cluster Management

```bash
# List clusters
kind get clusters

# Delete cluster
kind delete cluster --name k8s-learning

# Create new cluster
kind create cluster --name k8s-learning-2
```

## Learning Path

1. **Understand the cluster structure**
   - Explore nodes, pods, services
   - Learn about namespaces
   - Understand the control plane

2. **Manual component exploration**
   - Examine etcd data
   - Look at kube-apiserver logs
   - Understand kubelet configuration

3. **Deploy applications**
   - Create deployments
   - Configure services
   - Set up ingress

4. **Advanced topics**
   - RBAC and security
   - Storage and volumes
   - Networking policies

## Notes Directory

The `notes/` directory contains your progress tracking and learning notes.

## Benefits Over VM Approach

| Aspect | Vagrant/VMs | Kind |
|--------|-------------|------|
| **Setup Time** | 5-10 minutes | 30 seconds |
| **Networking** | Complex configuration | Automatic |
| **Resource Usage** | High (dedicated VMs) | Low (shared) |
| **Learning Focus** | Infrastructure issues | Kubernetes concepts |
| **Reproducibility** | Complex scripts | Single command |
| **Industry Usage** | Legacy approach | Modern standard |

## Next Steps

1. Complete the cluster setup above
2. Start with the progress tracking in `notes/progress.md`
3. Follow Kubernetes learning resources
4. Experiment and iterate quickly

## Troubleshooting

**Docker not running:**
```bash
# Start Docker Desktop or Docker service
sudo systemctl start docker
```

**Kind cluster issues:**
```bash
# Reset everything
kind delete cluster --name k8s-learning
kind create cluster --name k8s-learning
```

**Kubectl connection issues:**
```bash
# Ensure kubectl context is set
kubectl config current-context
kubectl config use-context kind-k8s-learning
``` 