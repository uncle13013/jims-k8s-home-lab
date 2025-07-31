# Kubernetes Infrastructure as Code

This directory contains Ansible playbooks for managing the complete Kubernetes cluster lifecycle using Infrastructure as Code principles.

## Playbook Overview

### 1. `01-docker-setup.yml`
**Purpose**: Configure Docker container runtime on all nodes
- Activates Docker service
- Configures Docker daemon for Kubernetes compatibility
- Sets up proper cgroup driver (systemd)

### 2. `02-kubernetes-setup.yml`
**Purpose**: Complete Kubernetes installation and configuration
- **Prerequisites**: Docker must be running on all nodes
- **Infrastructure Setup**: Kernel modules, sysctl parameters, directories
- **Control Plane**: Initialize master node with kubeadm
- **Worker Nodes**: Join workers to the cluster
- **CNI**: Install Calico networking
- **DNS**: Install CoreDNS for cluster DNS resolution
- **Verification**: Comprehensive cluster status checks

### 3. `03-test-networking.yml`
**Purpose**: Validate networking functionality
- Pod-to-pod connectivity testing
- DNS resolution verification
- Service connectivity validation
- Cross-node communication testing
- External connectivity verification

## Usage

### Prerequisites
1. All VMs must be running and accessible via SSH
2. Ansible inventory properly configured
3. SSH keys set up for passwordless access

### Deployment Order
```bash
# 1. Start VMs (if not running)
cd vagrant-cluster/toshiba-satellite && vagrant up
cd vagrant-cluster/hp-omen && vagrant up

# 2. Verify connectivity
ansible-playbook flatcar-ping.yml

# 3. Setup Docker
ansible-playbook 01-docker-setup.yml

# 4. Install Kubernetes with CNI
ansible-playbook 02-kubernetes-setup.yml

# 5. Test networking
ansible-playbook 03-test-networking.yml
```

### Idempotent Operations
All playbooks are designed to be idempotent:
- Check current state before making changes
- Skip operations if already completed
- Safe to run multiple times

### Configuration Variables
Key variables in `02-kubernetes-setup.yml`:
- `kubernetes_version`: "1.33.3"
- `calico_version`: "v3.28.0"
- `coredns_version`: "1.11.1"
- `pod_network_cidr`: "10.244.0.0/16"

## Architecture

### Network Configuration
- **Pod Network**: 10.244.0.0/16 (Calico)
- **Service Network**: 10.96.0.0/12 (Kubernetes default)
- **DNS Service**: 10.96.0.10 (CoreDNS)

### Components
- **Container Runtime**: Docker with systemd cgroup driver
- **CNI**: Calico for pod networking and network policies
- **DNS**: CoreDNS for cluster DNS resolution
- **Control Plane**: Single master (suitable for home lab)

## Troubleshooting

### Common Issues
1. **Docker not running**: Run `01-docker-setup.yml` first
2. **CNI not working**: Check Calico pods in kube-system namespace
3. **DNS issues**: Verify CoreDNS pods and service
4. **Node not joining**: Check join command and network connectivity

### Debug Commands
```bash
# Check cluster status
kubectl get nodes -o wide
kubectl get pods -A

# Check networking
kubectl get svc -A
kubectl get networkpolicies -A

# Check logs
kubectl logs -n kube-system -l k8s-app=calico-node
kubectl logs -n kube-system -l k8s-app=kube-dns
```

## Infrastructure as Code Benefits

### Version Control
- All configuration in Git
- Change history and rollback capability
- Team collaboration and review

### Reproducibility
- Identical environments across deployments
- Automated setup reduces human error
- Consistent configuration across nodes

### Maintainability
- Centralized configuration management
- Easy updates and modifications
- Documentation as code

### Scalability
- Easy to add new nodes
- Consistent node configuration
- Automated scaling procedures

## Security Considerations

### Network Policies
- Calico provides network policy enforcement
- Default deny policies can be applied
- Pod-to-pod communication control

### RBAC
- Kubernetes RBAC enabled by default
- Service account management
- Namespace isolation

### Container Security
- Docker security scanning
- Image vulnerability management
- Runtime security monitoring

## Monitoring and Observability

### Built-in Monitoring
- Kubernetes metrics server
- Calico metrics endpoint
- CoreDNS metrics

### Logging
- Container logs via kubectl
- System logs via journalctl
- Network logs via Calico

## Next Steps

### Production Enhancements
1. **High Availability**: Multiple master nodes
2. **Load Balancing**: MetalLB for bare metal
3. **Ingress**: NGINX or Traefik ingress controller
4. **Storage**: Persistent volume configuration
5. **Monitoring**: Prometheus and Grafana stack

### Security Hardening
1. **Network Policies**: Default deny policies
2. **Pod Security**: Pod security standards
3. **RBAC**: Fine-grained permissions
4. **Secrets Management**: External secrets operator

---

*This Infrastructure as Code approach ensures consistent, reproducible, and maintainable Kubernetes deployments.* 