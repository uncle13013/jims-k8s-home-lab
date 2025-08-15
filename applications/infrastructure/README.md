# Infrastructure Practice - CKA Domain 1 (25%)

This directory contains practical exercises for **Cluster Architecture, Installation & Configuration** - the highest weighted domain on the CKA exam.

## 🎯 Learning Objectives

- Infrastructure preparation for Kubernetes
- Cluster creation and management with kubeadm
- High-availability control plane setup
- Helm and Kustomize usage
- Custom Resource Definitions (CRDs) and operators

## 📋 Exercise Checklist

### Exercise 1: Basic Cluster Setup
- [ ] Prepare infrastructure requirements
- [ ] Install container runtime (containerd)
- [ ] Install kubeadm, kubelet, kubectl
- [ ] Initialize control plane
- [ ] Join worker nodes
- [ ] Verify cluster health

### Exercise 2: Cluster Lifecycle Management
- [ ] Upgrade cluster version
- [ ] Backup and restore etcd
- [ ] Scale control plane
- [ ] Node maintenance operations

### Exercise 3: High Availability
- [ ] Load balancer configuration
- [ ] Multiple control plane nodes
- [ ] etcd cluster setup
- [ ] Failover testing

### Exercise 4: Package Management
- [ ] Helm chart installation
- [ ] Custom Helm chart creation
- [ ] Kustomize overlays
- [ ] Configuration management

### Exercise 5: Extensions and CRDs
- [ ] Install CNI plugin
- [ ] Configure CSI driver
- [ ] Create custom resources
- [ ] Deploy operators

## 🚀 Quick Start

1. **Verify your 2-node cluster is running**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

2. **Check cluster health**:
   ```bash
   kubectl cluster-info
   kubectl get componentstatuses
   ```

3. **Start with Exercise 1** - Cluster Health Verification

## 📚 Reference Materials

- [kubeadm documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
- [Helm documentation](https://helm.sh/docs/)
- [Kustomize documentation](https://kustomize.io/)
- [CRD documentation](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)

## ⚠️ Important Notes

- **Practice on your local cluster** - don't break production systems
- **Document your steps** - this helps with exam preparation
- **Time your exercises** - simulate exam conditions
- **Focus on troubleshooting** - things will break, learn to fix them
