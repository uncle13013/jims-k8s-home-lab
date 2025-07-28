
# Jim's Kubernetes Home Lab

A production-ready Kubernetes cluster built across multiple machines using Infrastructure as Code principles. This project demonstrates enterprise-grade virtualization, networking, and automation techniques in a home lab environment.

## 🏗️ Architecture Overview

This is a **6-node Kubernetes cluster** running across two physical machines using Vagrant, VirtualBox, and Flatcar Linux. The setup showcases high availability, cross-machine networking, and Infrastructure as Code best practices.

### Current Infrastructure Status
- ✅ **6-node Kubernetes cluster** fully deployed and operational
- ✅ **Single master control plane** on always-available dedicated host
- ✅ **Ansible automation** for cluster management and configuration
- ✅ **Bridged networking** enabling direct LAN access to all nodes
- ✅ **Infrastructure as Code** with version-controlled Vagrant configurations

## 🖥️ Physical Infrastructure

### HP Omen Laptop (Mobile Development Host)
- **Role**: Mobile Kubernetes development environment
- **Nodes**: worker-1 (2GB), worker-2 (2GB), worker-3 (2GB), worker-4 (2GB)
- **Network**: Intel Wi-Fi 6E AX211 160MHz adapter with bridged networking
- **IPs**: 192.168.0.240-243

### Toshiba Satellite S55 (Always-On Infrastructure Host)  
- **Role**: Dedicated Kubernetes infrastructure and always-on services
- **Nodes**: master-1 (4GB), worker-5 (6GB)
- **Network**: wlp2s0 wireless adapter with bridged networking
- **IPs**: 192.168.0.244-245

### Network Topology
```
LAN (192.168.0.0/24)
├── HP Omen (Mobile Development)
│   ├── worker-1  (192.168.0.240) - 2GB
│   ├── worker-2  (192.168.0.241) - 2GB
│   ├── worker-3  (192.168.0.242) - 2GB
│   └── worker-4  (192.168.0.243) - 2GB
└── Toshiba Satellite (Always-On Infrastructure)
    ├── master-1  (192.168.0.244) - 4GB (Control Plane)
    └── worker-5  (192.168.0.245) - 6GB (Heavy-duty Always-On)
```

## 🛠️ Technology Stack

### Virtualization Platform
- **Vagrant 2.4.7**: Infrastructure as Code VM orchestration
- **VirtualBox 7.1.12**: Type-2 hypervisor with bridged networking support
- **WSL2 Mirrored Networking**: Direct LAN access from Windows Subsystem for Linux

### Operating System
- **Flatcar Linux 4230.2.1**: Container-optimized, security-focused Linux distribution
- **Immutable OS**: Updates via atomic transactions, perfect for Kubernetes
- **systemd-networkd**: Modern networking stack with predictable interface names

### Automation & Configuration
- **Ansible 2.16.3**: Configuration management and orchestration
- **Raw Module Strategy**: Custom approach for Flatcar's Python-free environment
- **SSH Key Management**: Secure authentication with proper key permissions

## 📁 Repository Structure

```
├── vagrant-cluster/
│   ├── hp-omen/
│   │   └── Vagrantfile           # 4-node configuration for primary host
│   └── toshiba-satellite/
│       └── Vagrantfile           # 2-node configuration for secondary host
├── ansible/
│   ├── inventory.yml             # 6-node cluster inventory with SSH config
│   ├── ansible.cfg              # Optimized Ansible configuration
│   ├── flatcar-ping.yml         # Flatcar-compatible connectivity testing
│   └── hello-world.yml          # Comprehensive system information gathering
├── ENGINEERING-NOTEBOOK.md      # Technical decisions and design rationale
└── README.md                    # This file
```
## 🚀 Quick Start Guide

### Prerequisites
- **Windows 11** with WSL2 (Ubuntu 22.04)
- **VirtualBox 7.1.12+** installed on Windows
- **Vagrant 2.4.7+** installed on Windows  
- **Two machines** connected to the same LAN
- **Ansible** installed in WSL2 environment

### Deployment Steps

1. **Clone and setup the repository**:
   ```bash
   git clone https://github.com/uncle13013/jims-k8s-home-lab.git
   cd jims-k8s-home-lab
   ```

2. **Deploy primary nodes (HP Omen)**:
   ```bash
   cd vagrant-cluster/hp-omen
   vagrant up
   ```

3. **Deploy secondary nodes (Toshiba Satellite)**:
   ```bash
   cd vagrant-cluster/toshiba-satellite  
   vagrant up
   ```

4. **Verify cluster connectivity**:
   ```bash
   cd ../../ansible
   ansible-playbook flatcar-ping.yml
   ```

### Expected Results
- **6 nodes** running Flatcar Linux with direct LAN access
- **All nodes accessible** via SSH from WSL2 environment
- **Cluster ready** for Kubernetes installation and configuration

## 🎯 Next Steps & Roadmap

### Phase 1: Kubernetes Installation (In Progress)
- [ ] Docker runtime activation across all nodes
- [ ] Kubernetes components installation (kubeadm, kubelet, kubectl)
- [ ] Single master control plane initialization
- [ ] Worker node joining and cluster validation

### Phase 2: Networking & Storage
- [ ] Container Network Interface (CNI) deployment
- [ ] Persistent volume configuration
- [ ] Load balancer and ingress setup
- [ ] Cross-node communication validation

### Phase 3: Applications & Monitoring  
- [ ] Monitoring stack (Prometheus, Grafana)
- [ ] CI/CD pipeline integration
- [ ] Sample application deployments
- [ ] Security scanning and hardening

## 📊 Resource Allocation

| Node | Machine | Role | CPU | RAM | Disk | IP |
|------|---------|------|-----|-----|------|----|
| worker-1 | HP Omen | Worker | 2 | 2GB | 20GB | 192.168.0.240 |
| worker-2 | HP Omen | Worker | 2 | 2GB | 20GB | 192.168.0.241 |
| worker-3 | HP Omen | Worker | 2 | 2GB | 20GB | 192.168.0.242 |
| worker-4 | HP Omen | Worker | 2 | 2GB | 20GB | 192.168.0.243 |
| master-1 | Toshiba | Control Plane | 2 | 4GB | 20GB | 192.168.0.244 |
| worker-5 | Toshiba | Heavy-duty Worker | 2 | 6GB | 20GB | 192.168.0.245 |

**Total Resources**: 12 vCPUs, 18GB RAM, 120GB Storage

## 🔧 Key Features

### Infrastructure as Code
- **Declarative configuration** with Vagrant and Ansible
- **Version-controlled infrastructure** in Git
- **Reproducible deployments** across different environments
- **Automated provisioning** with minimal manual intervention

### High Availability Design
- **Single master architecture** optimized for home lab reliability
- **Always-available control plane** on dedicated stable host
- **Static IP allocation** for predictable networking
- **Cross-machine workload distribution** for resource optimization

### Security & Compliance
- **Immutable OS** with Flatcar Linux
- **SSH key-based authentication** with proper permissions
- **Isolated networking** with bridged interfaces
- **Container runtime security** with systemd integration

### Operational Excellence
- **Monitoring ready** with systemd and logging
- **Ansible automation** for configuration management
- **Scalable architecture** for additional nodes
- **Documentation-driven** development approach

## 🔗 Related Documentation

- **[Engineering Notebook](./ENGINEERING-NOTEBOOK.md)**: Technical decisions, design rationale, and lessons learned
- **[Vagrant Cluster Directory](./vagrant-cluster/)**: Infrastructure as Code configurations
- **[Ansible Playbooks](./ansible/)**: Configuration management and automation scripts

## 📚 Learning Outcomes

This project demonstrates proficiency in:

### Infrastructure & Virtualization
- **Multi-machine virtualization** with VirtualBox and Vagrant
- **Cross-platform networking** between Windows and Linux environments
- **Bridged networking configuration** for production-like setups
- **Resource management** and capacity planning

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

### System Administration
- **SSH key management** and secure authentication
- **Linux system administration** across different distributions
- **Network troubleshooting** and configuration
- **Performance monitoring** and resource optimization

---

## 🏛️ Legacy Infrastructure (Preserved for Reference)

### Dell R610 Server (Retired)
The project originally used a Dell R610 server but was migrated to the current laptop-based setup due to power consumption concerns. The Dell R610 documentation is preserved in the `dell-r610/` directory for reference.

**Key Achievements**:
- ✅ **Automated KVM setup** with Ansible
- ✅ **Wake-on-LAN configuration** for remote power management  
- ✅ **Kali Linux VM** deployment with VNC access
- ✅ **Base system provisioning** with dependency management

**Migration Rationale**:
- **Power efficiency**: Laptops consume ~50W vs server ~300W
- **Noise reduction**: Server fans were disruptive in home environment  
- **Flexibility**: Laptop-based setup allows for mobile development
- **Cost optimization**: Reduced electricity costs and heat generation

---

*This repository serves as a portfolio demonstration of Infrastructure as Code, DevOps automation, and Kubernetes expertise. The project emphasizes production-ready practices, comprehensive documentation, and operational excellence.*
