# Storage Management Practice - CKA Domain 4 (10%)

This directory contains practical exercises for **Storage Management** - covering volume types, persistent storage, and dynamic provisioning.

## 🎯 Learning Objectives

- Storage classes and dynamic volume provisioning
- Volume types and access modes
- Persistent Volumes (PVs) and Persistent Volume Claims (PVCs)
- Storage backends and drivers
- Volume snapshots and backups
- Stateful applications and storage

## 📋 Exercise Checklist

### Exercise 1: Basic Volume Management
- [ ] EmptyDir volumes (temporary storage)
- [ ] HostPath volumes (node storage)
- [ ] ConfigMap and Secret volumes
- [ ] Volume mounting and permissions

### Exercise 2: Persistent Storage
- [ ] Create storage classes
- [ ] Define Persistent Volumes (PVs)
- [ ] Create Persistent Volume Claims (PVCs)
- [ ] Bind PVs to PVCs

### Exercise 3: Dynamic Provisioning
- [ ] Configure default storage class
- [ ] Dynamic volume creation
- [ ] Storage class parameters
- [ ] Reclaim policies

### Exercise 4: Stateful Applications
- [ ] Deploy database with persistent storage
- [ ] StatefulSet with volume claims
- [ ] Data persistence across pod restarts
- [ ] Backup and restore strategies

### Exercise 5: Advanced Storage Features
- [ ] Volume snapshots
- [ ] Volume expansion
- [ ] Storage quotas
- [ ] Multi-node storage

## 🚀 Quick Start

1. **Ensure your cluster is running**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

2. **Check available storage classes**:
   ```bash
   kubectl get storageclass
   ```

3. **Start with Exercise 1** - Basic Volume Management

## 📚 Reference Materials

- [Volumes documentation](https://kubernetes.io/docs/concepts/storage/volumes/)
- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

## ⚠️ Important Notes

- **Understand the difference** between PVs and PVCs
- **Practice dynamic provisioning** - it's commonly used
- **Learn storage classes** - they're essential for modern clusters
- **Focus on StatefulSets** - they're heavily tested
- **Know reclaim policies** - they affect data persistence
