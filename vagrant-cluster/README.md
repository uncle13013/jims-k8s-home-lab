# Vagrant Kubernetes Cluster Setup

This directory contains Vagrant configurations for setting up a multi-node Kubernetes cluster using Flatcar Linux.

## Cluster Architecture

### HP Omen (Local Machine)
- **master-1**: Control plane node
- **worker-1**: Worker node  
- **worker-2**: Worker node

### Toshiba Satellite S55
- **master-2**: Control plane node (HA setup)
- **worker-3**: Worker node
- **worker-4**: Worker node

## Resource Allocation

**Per Node:**
- **CPU**: 2 cores
- **RAM**: 4GB (masters), 2GB (workers)
- **Disk**: 20GB
- **OS**: Flatcar Linux (Container Linux)

**Total Resources:**
- **Masters**: 2 nodes × 4GB = 8GB RAM
- **Workers**: 4 nodes × 2GB = 8GB RAM
- **Total**: 16GB RAM, 120GB disk space

## Prerequisites

- VirtualBox installed
- Vagrant installed
- At least 16GB RAM available across both machines
- Network connectivity between machines

## Quick Start

1. **On HP Omen** (your local machine):
   ```bash
   cd vagrant-cluster/hp-omen
   vagrant up
   ```

2. **On Toshiba Satellite**:
   ```bash
   cd vagrant-cluster/toshiba-satellite
   vagrant up
   ```

3. **Initialize cluster** (from any master node):
   ```bash
   vagrant ssh master-1
   sudo kubeadm init --control-plane-endpoint=<load-balancer-ip>
   ```

## Files

- `hp-omen/Vagrantfile` - Local machine cluster nodes
- `toshiba-satellite/Vagrantfile` - Remote machine cluster nodes
- `provisioning/` - Shared provisioning scripts
- `kubeconfig/` - Kubernetes configuration files

## Network Configuration

The cluster uses a private network with static IPs:
- **HP Omen subnet**: 192.168.56.0/24
- **Toshiba Satellite subnet**: 192.168.57.0/24
- **Cross-machine networking**: Configured via host routes

## Next Steps

1. Set up the Vagrant environments
2. Configure networking between machines
3. Initialize Kubernetes cluster
4. Install CNI (Calico/Flannel)
5. Join worker nodes
6. Deploy test applications
