# Quick Start Guide - Vagrant Kubernetes Cluster

This guide will get your multi-node Kubernetes cluster up and running quickly.

## Prerequisites Check

Before starting, ensure you have:

```bash
# Check Vagrant version (should be 2.2+)
vagrant --version

# Check VirtualBox version (should be 6.0+)
vboxmanage --version

# Check available RAM (you need at least 16GB)
free -h

# Check disk space (you need at least 120GB free)
df -h
```

## Step 1: Start Local Nodes (HP Omen)

On your HP Omen laptop:

```bash
cd vagrant-cluster/hp-omen

# Start all nodes (master-1, worker-1, worker-2)
vagrant up

# Or start them individually
vagrant up master-1
vagrant up worker-1  
vagrant up worker-2

# Check status
vagrant status
```

## Step 2: Start Remote Nodes (Toshiba Satellite)

On your Toshiba Satellite:

```bash
cd vagrant-cluster/toshiba-satellite

# Start all nodes (master-2, worker-3, worker-4)
vagrant up

# Check status
vagrant status
```

## Step 3: Initialize Kubernetes Cluster

SSH into the primary master node:

```bash
# From HP Omen
cd vagrant-cluster/hp-omen
vagrant ssh master-1
```

Inside master-1:

```bash
# Check if Kubernetes is ready
sudo systemctl status kubelet
sudo systemctl status containerd

# Initialize the cluster (this happens automatically on first boot)
# But you can monitor the setup:
sudo journalctl -u setup-kubernetes.service -f

# Once complete, check cluster status
kubectl get nodes
kubectl get pods -A
```

## Step 4: Join Additional Nodes

Get the join command from master-1:

```bash
# On master-1
sudo cat /tmp/kubeadm-join-command
```

Copy this command and run it on each worker node:

```bash
# Example join command (yours will be different)
sudo kubeadm join 192.168.56.10:6443 --token abc123.def456 --discovery-token-ca-cert-hash sha256:123...
```

For the second master (master-2), use the control-plane join command:

```bash
# Get control-plane join command from master-1
sudo kubeadm init phase upload-certs --upload-certs
# Then use the control-plane join command
```

## Step 5: Configure kubectl Access

On your local machine (outside VMs):

```bash
# Copy kubeconfig from master-1
cd vagrant-cluster/hp-omen
vagrant ssh master-1 -c "cat /home/core/.kube/config" > ../kubeconfig/admin.conf

# Set KUBECONFIG
export KUBECONFIG=$(pwd)/../kubeconfig/admin.conf

# Test access
kubectl get nodes
kubectl get pods -A
```

## Step 6: Verify Cluster

```bash
# Check all nodes are Ready
kubectl get nodes -o wide

# Check system pods are running
kubectl get pods -n kube-system

# Deploy a test application
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl get services
```

## Troubleshooting

### Nodes not starting
```bash
# Check VirtualBox VMs
VBoxManage list runningvms

# Check Vagrant status
vagrant global-status

# Check VM logs
vagrant ssh <node-name>
sudo journalctl -u kubelet -f
```

### Networking issues
```bash
# Check CNI pods
kubectl get pods -n kube-system | grep calico

# Check node connectivity
vagrant ssh master-1 -c "ping 192.168.57.10"  # Test cross-subnet
```

### Join command expired
```bash
# Generate new join command
vagrant ssh master-1
sudo kubeadm token create --print-join-command
```

## Resource Monitoring

```bash
# Check resource usage on nodes
kubectl top nodes
kubectl top pods -A

# Check cluster info
kubectl cluster-info
kubectl get componentstatuses
```

## Next Steps

1. Install additional cluster tools (Helm, Ingress Controller)
2. Deploy monitoring stack (Prometheus, Grafana)
3. Set up persistent storage
4. Deploy your applications!

## Useful Commands

```bash
# Vagrant operations
vagrant up <node-name>      # Start specific node
vagrant halt <node-name>    # Stop specific node
vagrant reload <node-name>  # Restart and re-provision
vagrant destroy <node-name> # Delete node
vagrant ssh <node-name>     # SSH into node

# Kubernetes operations
kubectl get nodes
kubectl get pods -A
kubectl describe node <node-name>
kubectl logs <pod-name> -n <namespace>
```
