# CKA Study Plan & Practice Applications

This directory contains a comprehensive study plan and practical exercises for the **Certified Kubernetes Administrator (CKA)** exam, based on the [official CNCF curriculum](https://github.com/cncf/curriculum/blob/master/CKA_Curriculum_v1.33.pdf).

## 📚 Exam Curriculum Overview

| Domain | Weight | Focus Areas |
|--------|--------|-------------|
| **Cluster Architecture, Installation & Configuration** | **25%** | Infrastructure prep, kubeadm, cluster lifecycle, HA control plane, Helm/Kustomize, extensions, CRDs/operators |
| **Workloads & Scheduling** | **15%** | Application deployments, rolling updates, ConfigMaps/Secrets, autoscaling, primitives, pod scheduling, RBAC |
| **Services & Networking** | **20%** | Pod connectivity, Network Policies, Service types, Gateway API, Ingress, CoreDNS |
| **Storage** | **10%** | Storage classes, volume types, PVs/PVCs, dynamic provisioning |
| **Troubleshooting** | **30%** | Clusters/nodes, components, monitoring, logs, services/networking |

## 🎯 Study Plan Structure

### Phase 1: Foundation & Infrastructure (25%)
- [ ] **Cluster Setup & Management**
  - [ ] Infrastructure preparation
  - [ ] kubeadm cluster creation
  - [ ] Cluster lifecycle management
  - [ ] High-availability control plane
- [ ] **Cluster Tools & Extensions**
  - [ ] Helm package management
  - [ ] Kustomize configuration
  - [ ] CNI, CSI, CRI interfaces
  - [ ] CRDs and operators

### Phase 2: Application Management (15%)
- [ ] **Workload Deployment**
  - [ ] Application deployments
  - [ ] Rolling updates and rollbacks
  - [ ] ConfigMaps and Secrets
  - [ ] Autoscaling strategies
- [ ] **Scheduling & Access Control**
  - [ ] Pod scheduling and affinity
  - [ ] Resource limits and requests
  - [ ] RBAC implementation
  - [ ] Admission controllers

### Phase 3: Networking & Services (20%)
- [ ] **Service Communication**
  - [ ] Pod-to-pod connectivity
  - [ ] Service types (ClusterIP, NodePort, LoadBalancer)
  - [ ] Endpoints and service discovery
- [ ] **Advanced Networking**
  - [ ] Network Policies
  - [ ] Gateway API implementation
  - [ ] Ingress controllers
  - [ ] CoreDNS configuration

### Phase 4: Storage Management (10%)
- [ ] **Volume Management**
  - [ ] Storage classes
  - [ ] Volume types and access modes
  - [ ] Persistent Volumes (PVs)
  - [ ] Persistent Volume Claims (PVCs)
- [ ] **Dynamic Provisioning**
  - [ ] Storage class configuration
  - [ ] Dynamic volume creation
  - [ ] Reclaim policies

### Phase 5: Troubleshooting & Monitoring (30%)
- [ ] **Cluster Troubleshooting**
  - [ ] Cluster component issues
  - [ ] Node problems
  - [ ] Resource usage monitoring
- [ ] **Application Troubleshooting**
  - [ ] Pod and container issues
  - [ ] Service connectivity problems
  - [ ] Log analysis and debugging
- [ ] **Performance & Monitoring**
  - [ ] Resource utilization
  - [ ] Performance bottlenecks
  - [ ] Monitoring stack setup

## 🛠️ Practice Applications

### 1. Basic Infrastructure (`infrastructure/`)
- **Cluster Setup**: Multi-node cluster with kubeadm
- **HA Control Plane**: Load balancer configuration
- **Helm Charts**: Custom chart development
- **CRDs**: Custom resource definitions

### 2. Workload Management (`workloads/`)
- **Multi-tier App**: Frontend, backend, database
- **Rolling Updates**: Blue-green deployment strategies
- **Config Management**: ConfigMaps and Secrets
- **Autoscaling**: HPA and VPA examples

### 3. Networking (`networking/`)
- **Service Mesh**: Basic service communication
- **Network Policies**: Pod isolation and security
- **Ingress**: Traffic routing and SSL termination
- **DNS**: CoreDNS configuration

### 4. Storage (`storage/`)
- **Dynamic Provisioning**: Storage class examples
- **Volume Types**: Different storage backends
- **Stateful Applications**: Database persistence
- **Backup Strategies**: Volume snapshots

### 5. Troubleshooting (`troubleshooting/`)
- **Broken Deployments**: Common failure scenarios
- **Network Issues**: Connectivity problems
- **Resource Constraints**: CPU/memory limits
- **Security Issues**: RBAC and policies

## 📋 Study Checklist

### Week 1-2: Foundation
- [ ] Set up 2-node cluster with kubeadm
- [ ] Understand cluster architecture
- [ ] Practice basic kubectl commands
- [ ] Deploy simple applications

### Week 3-4: Workloads & Scheduling
- [ ] Deploy multi-tier applications
- [ ] Practice rolling updates
- [ ] Configure resource limits
- [ ] Implement basic RBAC

### Week 5-6: Networking & Services
- [ ] Configure different service types
- [ ] Implement Network Policies
- [ ] Set up Ingress controllers
- [ ] Understand CoreDNS

### Week 7-8: Storage & Advanced Topics
- [ ] Configure storage classes
- [ ] Work with PVs and PVCs
- [ ] Implement dynamic provisioning
- [ ] Explore CRDs and operators

### Week 9-10: Troubleshooting & Practice
- [ ] Practice troubleshooting scenarios
- [ ] Monitor cluster performance
- [ ] Debug common issues
- [ ] Take practice exams

## 🎯 Exam Tips

### Time Management
- **Troubleshooting (30%)**: 54 minutes - Focus on quick diagnosis
- **Cluster Architecture (25%)**: 45 minutes - Infrastructure and tools
- **Services & Networking (20%)**: 36 minutes - Configuration and policies
- **Workloads (15%)**: 27 minutes - Deployments and scheduling
- **Storage (10%)**: 18 minutes - Volume management

### Key Skills to Master
1. **kubectl commands** - Know them by heart
2. **YAML editing** - Fast and accurate
3. **Troubleshooting flow** - Systematic approach
4. **Resource management** - Limits, requests, quotas
5. **Security concepts** - RBAC, Network Policies, Security Contexts

### Practice Scenarios
- Cluster component failures
- Pod scheduling issues
- Service connectivity problems
- Storage provisioning errors
- Resource constraint troubleshooting

## 📖 Resources

- **[Official CKA Curriculum](https://github.com/cncf/curriculum/blob/master/CKA_Curriculum_v1.33.pdf)**
- **[Kubernetes Documentation](https://kubernetes.io/docs/)**
- **[kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)**
- **[CKA Practice Tests](https://github.com/walidshaari/Kubernetes-Certified-Administrator)**

## 🚀 Getting Started

1. **Review the curriculum** and understand weightings
2. **Your cluster is ready** - 2-node setup with kubeadm and Calico CNI
3. **Start with Phase 1** - verify cluster health and understand components
4. **Practice each domain** with real applications
5. **Focus on troubleshooting** - it's 30% of the exam
6. **Time your practice** - simulate exam conditions

---

*Remember: The CKA exam is hands-on. Practice building, breaking, and fixing things in your cluster every day!*
