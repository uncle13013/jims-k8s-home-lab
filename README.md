
# Jim's Kubernetes Home Lab

A production-ready Kubernetes cluster built across multiple machines using Infrastructure as Code principles. This project demonstrates enterprise-grade virtualization, networking, and automation techniques in a home lab environment.

## 🏗️ Architecture Overview

This is a **2-node Kubernetes cluster** running locally using VirtualBox with kubeadm and Calico CNI. The setup showcases high availability, local networking, and Infrastructure as Code best practices for CKA exam preparation.

### Current Infrastructure Status
- ✅ **2-node Kubernetes cluster** fully deployed and operational
- ✅ **Single master control plane** with dedicated worker node
- ✅ **kubeadm cluster** with Calico CNI networking
- ✅ **Local networking** enabling direct access to all nodes
- ✅ **Ready for CKA exam study** with toy application deployments

## 🖥️ Current Infrastructure

### Local Development Environment
- **Role**: Local Kubernetes development and CKA exam study environment
- **Nodes**: master-1 (4GB), worker-1 (2GB)
- **Network**: Local VirtualBox networking with Calico CNI
- **IPs**: Local network range with direct access

### Network Topology
```
Local Network
├── master-1  (Control Plane) - 4GB
└── worker-1  (Worker Node) - 2GB
```

## 🛠️ Technology Stack

### Virtualization Platform
- **VirtualBox**: Type-2 hypervisor with local networking support
- **kubeadm**: Kubernetes cluster lifecycle management
- **Calico CNI**: Advanced networking with policy support
- **Local Development**: Optimized for single-machine Kubernetes study

### Operating System
- **Linux**: Container-optimized, security-focused distribution
- **systemd**: Modern system management with predictable interface names
- **Container Runtime**: containerd with systemd cgroup driver

### Automation & Configuration
- **kubeadm**: Kubernetes cluster lifecycle management
- **Calico CNI**: Advanced networking with policy support
- **kubectl**: Command-line interface for cluster management

## 📁 Repository Structure

```
├── applications/                 # Toy applications for CKA exam study
│   ├── infrastructure/          # Cluster architecture and management
│   ├── workloads/               # Application deployment and scheduling
│   ├── networking/              # Services, networking, and policies
│   ├── storage/                 # Volume management and persistence
│   └── troubleshooting/         # Debugging and problem resolution
├── ENGINEERING-NOTEBOOK.md      # Technical decisions and design rationale
└── README.md                    # This file
```

## 🚀 Quick Start Guide

### Prerequisites
- **Running 2-node Kubernetes cluster** with kubeadm and Calico CNI
- **kubectl configured** and working
- **Basic Kubernetes knowledge** for CKA exam preparation

### Getting Started

1. **Verify your cluster is running**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

2. **Check cluster health**:
   ```bash
   kubectl cluster-info
   kubectl get componentstatuses
   ```

3. **Start with Infrastructure Exercise 1** - Cluster Health Verification

### Expected Results
- **2 nodes** running Kubernetes with Calico CNI
- **All components healthy** and operational
- **Cluster ready** for CKA exam study and practice

## 🎯 Current Focus: CKA Exam Preparation

### Phase 1: Kubernetes Installation ✅
- [x] Container runtime (containerd) running on all nodes
- [x] Kubernetes components (kubeadm, kubelet, kubectl) installed
- [x] Single master control plane initialized and running
- [x] Worker node joined and cluster validated
- [x] Calico CNI installed and configured

### Phase 2: Toy Applications for CKA Study 🚧
- [ ] **Basic Deployments**: nginx, busybox, and simple web applications
- [ ] **Multi-tier Applications**: Frontend, backend, and database deployments
- [ ] **Troubleshooting Scenarios**: Common CKA exam problems and solutions
- [ ] **Resource Management**: CPU, memory, and storage allocation examples
- [ ] **Networking**: Services, ingress, and network policies
- [ ] **Security**: RBAC, security contexts, and pod security standards
- [ ] **Storage**: Persistent volumes, storage classes, and dynamic provisioning
- [ ] **Monitoring**: Basic monitoring and logging setup

### Phase 3: Advanced CKA Topics
- [ ] **Cluster Maintenance**: Upgrades, backup, and disaster recovery
- [ ] **Performance Tuning**: Resource optimization and troubleshooting
- [ ] **Security Hardening**: Network policies, admission controllers
- [ ] **Custom Resources**: CRDs and operators
- [ ] **Multi-cluster Management**: Federation and multi-tenancy

## 📊 Resource Allocation

| Node | Role | CPU | RAM | Disk | Purpose |
|------|------|-----|-----|------|---------|
| master-1 | Control Plane | 2 | 4GB | 20GB | Kubernetes API and control plane |
| worker-1 | Worker | 2 | 2GB | 20GB | Application workloads and CKA practice |

**Total Resources**: 4 vCPUs, 6GB RAM, 40GB Storage

## 🔧 Key Features

### Infrastructure as Code
- **Declarative configuration** with Vagrant and Ansible
- **Version-controlled infrastructure** in Git
- **Reproducible deployments** across different environments
- **Automated provisioning** with minimal manual intervention

### CKA Exam Focus
- **Real-world scenarios** with actual cluster deployments
- **Troubleshooting practice** on live Kubernetes clusters
- **Hands-on experience** with all major Kubernetes components
- **Performance optimization** and resource management practice

### Security & Compliance
- **Immutable OS** with Flatcar Linux
- **SSH key-based authentication** with proper permissions
- **Local networking** with isolated interfaces
- **Container runtime security** with systemd integration

### Operational Excellence
- **Monitoring ready** with systemd and logging
- **Ansible automation** for configuration management
- **Scalable architecture** for additional nodes
- **Documentation-driven** development approach

## 🎓 CKA Study Applications

### Basic Deployments
- **nginx-deployment**: Simple web server with scaling examples
- **busybox-deployment**: Lightweight container for testing
- **hello-world**: Basic application deployment patterns

### Multi-tier Applications
- **web-app**: Frontend, backend, and database architecture
- **api-gateway**: Service mesh and API management examples
- **data-pipeline**: Batch processing and streaming applications

### Troubleshooting Scenarios
- **broken-pods**: Common pod startup issues
- **network-issues**: Service connectivity problems
- **resource-constraints**: CPU and memory limitations
- **storage-problems**: Volume mounting and persistence issues

### Advanced Topics
- **custom-resources**: CRD development and usage
- **operators**: Kubernetes operator patterns
- **multi-cluster**: Federation and cluster management
- **security-policies**: Pod security standards and network policies

## 🔗 Related Documentation

- **[Engineering Notebook](./ENGINEERING-NOTEBOOK.md)**: Technical decisions, design rationale, and lessons learned
- **[Vagrant Cluster Directory](./vagrant-cluster/)**: Infrastructure as Code configurations
- **[Ansible Playbooks](./ansible/)**: Configuration management and automation scripts
- **[Applications Directory](./applications/)**: CKA study applications and examples

## 📚 Learning Outcomes

This project demonstrates proficiency in:

### CKA Exam Preparation
- **Real cluster experience** with actual deployments
- **Troubleshooting practice** on live systems
- **Performance optimization** and resource management
- **Security configuration** and policy implementation
- **Official curriculum coverage** based on [CNCF CKA Curriculum v1.33](https://github.com/cncf/curriculum/blob/master/CKA_Curriculum_v1.33.pdf)

### Infrastructure & Virtualization
- **Local virtualization** with VirtualBox and Vagrant
- **Kubernetes cluster design** and implementation
- **Resource management** and capacity planning
- **Network configuration** and troubleshooting

### DevOps & Automation
- **Infrastructure as Code** principles and implementation
- **Configuration management** with Ansible in containerized environments
- **Version control** for infrastructure configurations
- **Automated deployment** pipelines

### Kubernetes & Containerization
- **Multi-node cluster architecture** design and implementation
- **High availability** patterns for production workloads
- **Container-optimized operating systems** and their trade-offs
- **Network policy** and security considerations

### CKA Exam Preparation
- **Real cluster experience** with actual deployments
- **Troubleshooting practice** on live systems
- **Performance optimization** and resource management
- **Security configuration** and policy implementation

---

## 🏛️ Legacy Infrastructure (Preserved for Reference)

### Multi-Machine Setup (Previous Version)
The project previously used a 6-node setup across two physical machines but has been simplified to a local 2-node setup for focused CKA exam study.

**Previous Architecture**:
- **HP Omen Laptop**: 4 worker nodes (2GB each)
- **Toshiba Satellite**: 1 master (4GB) + 1 worker (6GB)
- **Total**: 6 nodes, 12 vCPUs, 18GB RAM

**Simplification Rationale**:
- **Focused learning**: Local setup allows for concentrated CKA study
- **Resource efficiency**: Reduced resource consumption for development
- **Faster iteration**: Quicker deployment and testing cycles
- **Portability**: Easy to move between different development environments

---

*This repository serves as a focused Kubernetes learning environment for CKA exam preparation, emphasizing hands-on practice with real cluster deployments, troubleshooting scenarios, and production-ready application patterns.*
