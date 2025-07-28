# Self-Hosted Kubernetes Binary Repository

This creates a **self-sustaining cluster** where the binary repository runs inside the cluster itself, providing a cloud-native approach to new node bootstrapping.

## 🎯 Architecture Benefits

- **🔄 Self-sustaining**: Cluster hosts its own bootstrap binaries
- **⚡ Fast local access**: Binaries served from within cluster
- **🔒 Secure**: No external dependencies after initial setup
- **🏠 HA ready**: Multiple replicas and fallback mechanisms
- **📊 Observable**: Standard Kubernetes monitoring/logging

## 📋 Deployment Process

### 1. Bootstrap First Node (Manual)
```bash
# Start with one node using upstream binaries
cd vagrant-cluster/toshiba-satellite
vagrant up master-1

# SSH and initialize cluster
vagrant ssh master-1
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

### 2. Deploy Binary Repository
```bash
# Apply the binary repository infrastructure
kubectl apply -f k8s-manifests/binary-repository.yaml

# Wait for deployment
kubectl wait --for=condition=available --timeout=300s deployment/k8s-binary-repo -n k8s-binary-repo

# Populate the repository
kubectl apply -f k8s-manifests/populate-binary-repo-job.yaml

# Check job completion
kubectl logs -f job/populate-binary-repo -n k8s-binary-repo
```

### 3. Verify Repository
```bash
# Check service is running
kubectl get svc -n k8s-binary-repo

# Test internal access
kubectl run test-repo --image=curlimages/curl --rm -it --restart=Never -- \
  curl -s http://k8s-binary-repo-service.k8s-binary-repo.svc.cluster.local/versions.json

# Test external access (NodePort)
curl http://192.168.0.244:30080/versions.json
```

### 4. Deploy Additional Nodes
```bash
# Now all new nodes will download from cluster repository
vagrant up worker-5

# The download script automatically tries:
# 1. Cluster internal service (preferred)
# 2. NodePort on existing nodes (fallback)
# 3. Upstream sources (emergency fallback)
```

## 🔍 Repository Structure

```
Binary Repository (PV):
├── kubernetes/
│   └── v1.28.2/
│       ├── kubelet
│       ├── kubeadm
│       └── kubectl
├── cni/
│   └── v1.3.0/
│       └── cni-plugins.tgz
├── checksums.txt
├── versions.json
└── index.html
```

## 🌐 Access Methods

| Method | URL | Use Case |
|--------|-----|----------|
| **Cluster Internal** | `http://k8s-binary-repo-service.k8s-binary-repo.svc.cluster.local` | Existing cluster nodes |
| **NodePort** | `http://192.168.0.244:30080` | New nodes during bootstrap |
| **Web Interface** | `http://192.168.0.244:30080` | Human browsing/verification |

## 🔧 Download Logic (New Nodes)

```bash
# The download script tries in order:
1. Cluster service (if cluster DNS works)
2. NodePort on master-1 (192.168.0.244:30080)
3. NodePort on worker-5 (192.168.0.245:30080)
4. Upstream sources (fallback)
```

This provides **3 levels of redundancy** while preferring cluster-internal sources.

## 🔐 Security Features

- **Checksum verification**: All binaries verified against SHA256 checksums
- **Network isolation**: Internal cluster traffic preferred
- **Resource limits**: Repository pods have CPU/memory limits
- **Health checks**: Liveness and readiness probes

## 📊 Monitoring

```bash
# Check repository health
kubectl get pods -n k8s-binary-repo

# View logs
kubectl logs -l app=k8s-binary-repo -n k8s-binary-repo

# Check resource usage
kubectl top pods -n k8s-binary-repo
```

## 🚀 Scaling

The repository scales automatically:
- **Multiple replicas**: 2 nginx pods for HA
- **Shared storage**: All replicas serve same PV
- **Load balancing**: Kubernetes service distributes requests

## 🔄 Updates

To update Kubernetes versions:
1. Update the job manifest with new versions
2. Run the populate job again
3. New nodes automatically get updated binaries

This creates a **truly self-sustaining cluster** where the infrastructure provides for its own growth! 🎯
