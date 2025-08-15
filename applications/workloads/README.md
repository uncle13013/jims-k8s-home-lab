# Workloads & Scheduling Practice - CKA Domain 2 (15%)

This directory contains practical exercises for **Workloads & Scheduling** - covering application deployments, configuration management, and resource scheduling.

## 🎯 Learning Objectives

- Application deployments and lifecycle management
- Rolling updates and rollbacks
- ConfigMaps and Secrets management
- Autoscaling strategies (HPA, VPA)
- Pod scheduling and affinity
- RBAC implementation
- Resource limits and requests

## 📋 Exercise Checklist

### Exercise 1: Basic Application Deployment
- [ ] Deploy simple applications (nginx, busybox)
- [ ] Understand deployment objects
- [ ] Practice kubectl run vs apply
- [ ] Manage pod lifecycle

### Exercise 2: Multi-tier Application
- [ ] Frontend deployment (nginx)
- [ ] Backend API deployment
- [ ] Database deployment (stateful)
- [ ] Service configuration

### Exercise 3: Configuration Management
- [ ] Create and use ConfigMaps
- [ ] Manage Secrets securely
- [ ] Environment variable injection
- [ ] Configuration updates

### Exercise 4: Rolling Updates & Rollbacks
- [ ] Deploy application with multiple replicas
- [ ] Perform rolling update
- [ ] Rollback to previous version
- [ ] Monitor update progress

### Exercise 5: Autoscaling
- [ ] Horizontal Pod Autoscaler (HPA)
- [ ] Vertical Pod Autoscaler (VPA)
- [ ] Resource metrics
- [ ] Scaling policies

### Exercise 6: Advanced Scheduling
- [ ] Node affinity and anti-affinity
- [ ] Pod affinity and anti-affinity
- [ ] Taints and tolerations
- [ ] Resource quotas and limits

### Exercise 7: RBAC & Security
- [ ] Service accounts
- [ ] Roles and RoleBindings
- [ ] ClusterRoles and ClusterRoleBindings
- [ ] Security contexts

## 🚀 Quick Start

1. **Ensure your cluster is running**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

2. **Start with Exercise 1** - Basic Application Deployment

3. **Practice each concept** with real applications

## 📚 Reference Materials

- [Deployments documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [ConfigMaps and Secrets](https://kubernetes.io/docs/concepts/configuration/)
- [Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## ⚠️ Important Notes

- **Start simple** - master basic deployments before advanced features
- **Practice rollbacks** - this is common on the CKA exam
- **Understand RBAC** - security is heavily tested
- **Resource management** - know how to set limits and requests
