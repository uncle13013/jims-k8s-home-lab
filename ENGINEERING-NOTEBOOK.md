# Engineering Notebook: Jim's Kubernetes Home Lab

*A technical log of design decisions, challenges, and solutions in building a production-ready Kubernetes cluster across multiple physical machines.*

---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture Decisions](#architecture-decisions)
- [Technical Challenges & Solutions](#technical-challenges--solutions)
- [Infrastructure Evolution](#infrastructure-evolution)
- [Lessons Learned](#lessons-learned)
- [Performance & Optimization](#performance--optimization)
- [Security Considerations](#security-considerations)
- [Future Enhancements](#future-enhancements)

---

## Project Overview

### Initial Requirements
- **Multi-node Kubernetes cluster** for learning and experimentation
- **High availability** control plane design
- **Power efficiency** (migrated from Dell R610 due to ~300W consumption)
- **Production-like networking** with LAN accessibility
- **Infrastructure as Code** for reproducible deployments
- **Cross-machine distribution** for fault tolerance

### Success Metrics
- ✅ **6-node cluster** operational across 2 physical machines
- ✅ **HA control plane** with masters on different hosts
- ✅ **Direct LAN access** to all nodes from any network client
- ✅ **Ansible automation** working with container-optimized OS
- ✅ **Sub-60W total power consumption** (2 laptops vs 300W server)

---

## Architecture Decisions

### AD-001: VirtualBox over KVM/libvirt
**Date**: 2025-07-15  
**Decision**: Use VirtualBox instead of KVM for virtualization

**Context**: 
- Initial preference was KVM/libvirt for performance
- Both physical machines connect via WiFi, not Ethernet
- Need bridged networking for direct LAN access to VMs

**Rationale**:
- **WiFi bridging limitation**: KVM bridged networking requires Ethernet adapters
- **VirtualBox WiFi support**: VirtualBox supports bridged networking over WiFi interfaces
- **Cross-platform consistency**: VirtualBox works identically on both Windows machines
- **Vagrant integration**: Excellent Vagrant support with mature provider

**Trade-offs**:
- ❌ **Performance**: ~10-15% overhead vs KVM
- ❌ **Memory efficiency**: Type-2 hypervisor overhead
- ✅ **WiFi bridging**: Works reliably with wireless adapters
- ✅ **Windows integration**: Native Windows support without WSL complications

**Validation**: Successfully bridged across `Intel(R) Wi-Fi 6E AX211 160MHz` (HP Omen) and `wlp2s0` (Toshiba Satellite)

### AD-005: Architecture Restructure for Operational Reliability
**Date**: 2025-07-28  
**Decision**: Restructure cluster to single master on dedicated always-on host with optimized worker distribution

**Context**: 
- HP Omen laptop frequently taken offline (mobile use, shutdown cycles)
- Need always-available cluster control plane
- Toshiba Satellite dedicated exclusively to cluster (16GB RAM available)
- Requirement for persistent services (network monitoring, torrent client)

**Physical Hardware Assessment**:
```
Toshiba Satellite S55 Specifications:
- CPU: Intel Core i7-4700MQ @ 2.40GHz (4 cores, 8 threads)  
- RAM: 16GB total (12GB available after host OS)
- Current allocation: 4GB used (2x 2GB worker VMs)
- Available capacity: ~8GB additional headroom
```

**New Architecture**:
```
HP Omen (Mobile Development):     worker-1, worker-2, worker-3, worker-4 (2GB each)
Toshiba (Always-On Infrastructure): master-1 (4GB), worker-5 (6GB)
```

**Rationale**:
- **Operational stability**: Control plane always available regardless of HP Omen status
- **Resource optimization**: Better utilization of Toshiba's 16GB capacity
- **Service isolation**: Always-on worker (worker-5) perfect for persistent services
- **Development flexibility**: 4 mobile workers for development/testing workflows
- **Simplified HA**: Single master reduces complexity while meeting home lab reliability needs

**Trade-offs**:
- ❌ **No master redundancy**: Single point of failure for control plane
- ❌ **Less "production-like"**: Most production clusters use multiple masters
- ✅ **Operational reliability**: Master always available on stable host
- ✅ **Resource efficiency**: Better RAM utilization (18GB vs 16GB total)
- ✅ **Service continuity**: Always-on worker for persistent workloads
- ✅ **Cost optimization**: Single master reduces resource overhead

**Implementation Details**:
- **Master placement**: Toshiba 192.168.0.244 (4GB RAM allocation)
- **Heavy-duty worker**: Toshiba 192.168.0.245 (6GB RAM allocation)  
- **Mobile workers**: HP Omen 192.168.0.240-243 (2GB each)
- **Total resources**: 6 nodes, 18GB RAM, 12 vCPUs
- **Host headroom**: 2GB on Toshiba, 4GB+ on HP Omen

**Validation Criteria**:
- Control plane accessible 24/7 from development environment
- Worker-5 capable of running monitoring stack + persistent services
- Mobile workers sufficient for development and testing workloads
- Cluster survives HP Omen offline cycles

**Validation**: Successfully bridged across `Intel(R) Wi-Fi 6E AX211 160MHz` (HP Omen) and `wlp2s0` (Toshiba Satellite)

### AD-002: Flatcar Linux over Ubuntu/CentOS
**Date**: 2025-07-16  
**Decision**: Use Flatcar Linux for all Kubernetes nodes

**Context**:
- Need container-optimized OS for Kubernetes workloads
- Security and immutability requirements
- Automated update capabilities

**Rationale**:
- **Container-first design**: Optimized for container workloads
- **Immutable filesystem**: Atomic updates, reduced security surface
- **Minimal footprint**: ~500MB RAM usage vs 1GB+ for general-purpose distros
- **CoreOS heritage**: Proven in production Kubernetes environments
- **Auto-updates**: Built-in update engine for security patches

**Trade-offs**:
- ❌ **Python unavailable**: Complicates Ansible automation (requires raw module)
- ❌ **Package management**: No traditional package manager (uses containers)
- ❌ **Learning curve**: Different from traditional Linux distributions
- ✅ **Security**: Hardened by default, minimal attack surface
- ✅ **Reliability**: Immutable system reduces configuration drift
- ✅ **Performance**: Optimized for container runtime performance

**Validation**: All 6 nodes running stable on Flatcar 4230.2.1 with kernel 6.6.95-flatcar

### AD-003: Static IP Assignment
**Date**: 2025-07-18  
**Decision**: Use static IP addresses (192.168.0.240-245) instead of DHCP

**Context**:
- Need predictable networking for Kubernetes cluster
- Ansible inventory requires stable addresses
- LAN integration for external access

**Rationale**:
- **Predictability**: Known IP addresses for all cluster components
- **Ansible compatibility**: Static inventory without dynamic discovery
- **External access**: Other LAN devices can reach cluster services
- **DNS integration**: Can configure local DNS entries if needed

**Implementation**:
```ruby
# Vagrant networking configuration
config.vm.network "public_network", ip: "192.168.0.240", bridge: "Intel(R) Wi-Fi 6E AX211 160MHz"
```

**Validation**: All nodes accessible on LAN, no IP conflicts detected

### AD-004: WSL2 Mirrored Networking
**Date**: 2025-07-20  
**Decision**: Enable WSL2 mirrored networking mode for Ansible access

**Context**:
- WSL2 runs in isolated network namespace by default
- Need direct access to VM IPs from WSL2 for Ansible
- VirtualBox VMs use bridged networking on Windows host

**Problem**:
- Default WSL2 NAT networking couldn't reach bridged VMs
- Manual port forwarding would be complex and fragile
- Ansible requires direct SSH access to all nodes

**Solution**:
```ini
# ~/.wslconfig
[wsl2]
networkingMode=mirrored
```

**Impact**:
- ✅ **Direct LAN access**: WSL2 can reach all VM IPs directly
- ✅ **Simplified networking**: No port forwarding or NAT traversal
- ✅ **Ansible compatibility**: Standard SSH connections work
- ❌ **WSL2 dependency**: Requires Windows 11 22H2+ with mirrored networking

---

## Technical Challenges & Solutions

### TC-001: Flatcar Python Interpreter Issue
**Date**: 2025-07-22  
**Challenge**: Ansible fails with "No Python interpreter found" on Flatcar Linux

**Error**:
```
UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: /usr/bin/python3: No such file or directory", "unreachable": true}
```

**Root Cause**: Flatcar Linux is container-optimized and doesn't include Python interpreter

**Investigation**:
```bash
ssh core@192.168.0.240 'ls /usr/bin/ | grep -E "(python|sh|bash)"'
# Output: bash (confirmed bash available)
ssh core@192.168.0.240 'which python python3 python2'
# Output: (no output - Python not found)
```

**Solution**: Use Ansible raw module for Flatcar-specific playbooks
```yaml
- name: Test raw connectivity with basic commands
  raw: |
    echo "=== Node Information ==="
    echo "Hostname: $(hostname)"
    echo "IP Address: $(hostname -I | awk '{print $1}')"
    echo "Uptime: $(uptime)"
    # ... additional commands
  register: node_info
```

**Outcome**: Successfully automated Flatcar management without Python dependency

### TC-002: SSH Key Permissions
**Date**: 2025-07-19  
**Challenge**: SSH connection failures due to key permission issues

**Error**:
```
UNREACHABLE! => {"msg": "Failed to connect to the host via ssh: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @\r\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\nPermissions 0777 for '/mnt/c/Users/.../.vagrant.d/insecure_private_key' are too open."}
```

**Root Cause**: Windows filesystem permissions (777) too permissive for SSH keys in WSL2

**Solution**: Copy keys to WSL2 filesystem and set proper permissions
```bash
# Copy keys to WSL2 filesystem
cp /mnt/c/Users/jknoc/.vagrant.d/insecure_private_key ~/.ssh/vagrant_key_rsa
cp /mnt/c/Users/jknoc/.vagrant.d/insecure_private_key_ed25519 ~/.ssh/vagrant_key_ed25519

# Set correct permissions
chmod 600 ~/.ssh/vagrant_key_*
```

**Lesson Learned**: WSL2 respects Unix permissions only on Linux filesystem, not Windows mounts

### TC-003: Bridge Interface Name Discovery
**Date**: 2025-07-17  
**Challenge**: Different WiFi adapter names across machines

**Context**:
- HP Omen: `"Intel(R) Wi-Fi 6E AX211 160MHz"`
- Toshiba Satellite: `"wlp2s0"`

**Discovery Process**:
```bash
# Windows PowerShell - List network adapters
Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object Name, InterfaceDescription

# Linux - List wireless interfaces  
ip link show | grep -E "^[0-9]+:|wlp|wlan"
```

**Solution**: Machine-specific Vagrantfiles with correct bridge interfaces
```ruby
# HP Omen configuration
config.vm.network "public_network", ip: "192.168.0.240", bridge: "Intel(R) Wi-Fi 6E AX211 160MHz"

# Toshiba Satellite configuration  
config.vm.network "public_network", ip: "192.168.0.244", bridge: "wlp2s0"
```

**Validation**: Both machines successfully bridge to LAN with proper interface names

### TC-004: VirtualBox VM Boot Timeouts
**Date**: 2025-07-16  
**Challenge**: Flatcar VMs timing out during initial boot (300s default)

**Symptoms**:
- VMs start but don't become SSH-accessible within timeout
- Flatcar Linux taking longer to initialize than expected
- Network configuration delays

**Solution**: Increase boot timeout and optimize VM settings
```ruby
# Increase boot timeout for Flatcar
config.vm.boot_timeout = 600  # 10 minutes

# Enable nested virtualization for container performance
vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]

# Use default paravirtualization 
vb.customize ["modifyvm", :id, "--paravirtprovider", "default"]
```

**Outcome**: Reliable VM boot times ~2-4 minutes, well within 10-minute timeout

---

## Infrastructure Evolution

### Phase 1: Dell R610 Server (Deprecated)
**Duration**: 2024-12-15 to 2025-07-10  
**Architecture**: Single physical server with KVM virtualization

**Achievements**:
- ✅ Automated Kali Linux VM deployment with Ansible
- ✅ Wake-on-LAN configuration for power management
- ✅ VNC-based remote management
- ✅ Comprehensive system provisioning

**Challenges**:
- ❌ **Power consumption**: ~300W continuous draw
- ❌ **Noise levels**: Server fans disruptive in home environment
- ❌ **Single point of failure**: No physical redundancy
- ❌ **Heat generation**: Required cooling considerations

**Migration Decision**: Cost and environmental factors outweighed performance benefits

### Phase 2: Multi-Laptop Cluster (Current)
**Duration**: 2025-07-10 to Present  
**Architecture**: Distributed VMs across HP Omen and Toshiba Satellite

**Improvements**:
- ✅ **Power efficiency**: ~50W total consumption (2 laptops)
- ✅ **Physical redundancy**: Distributed across different machines
- ✅ **Noise reduction**: Silent operation in home environment
- ✅ **Mobility**: Can relocate cluster components if needed

**Evolution 2.1: Operational Reliability Optimization (2025-07-28)**:
- **Problem**: HP Omen mobile usage caused control plane downtime
- **Solution**: Single master on always-on Toshiba Satellite
- **Resource redistribution**: 4x2GB mobile workers + 1x6GB always-on worker
- **Result**: 24/7 cluster availability with optimized resource allocation

**Current Challenges**:
- ⚠️ **Single master**: No control plane redundancy (acceptable for home lab)
- ⚠️ **Network coordination**: Cross-machine networking complexity  
- ⚠️ **Host dependency**: Toshiba must remain operational for cluster function

**Validation**: Successfully running 6-node cluster with operational stability and resource optimization

---

## Lessons Learned

### LL-001: Container-Optimized OS Trade-offs
**Insight**: Flatcar Linux's Python-free design requires automation tool adaptation

**Impact**: 
- Traditional Ansible playbooks fail without Python interpreter
- Raw/shell modules become primary automation interface
- Infrastructure as Code still achievable but requires different approach

**Best Practice**: 
- Design automation with OS capabilities in mind
- Test configuration management early in OS selection process
- Consider multiple automation strategies for different OS types

### LL-002: Cross-Platform Networking Complexity
**Insight**: Windows + WSL2 + VirtualBox + WiFi bridging creates multiple integration points

**Key Factors**:
- WSL2 network isolation requires mirrored networking mode
- VirtualBox bridge interface names vary by machine
- SSH key permissions behave differently on Windows vs Linux filesystems

**Best Practice**:
- Document exact interface names for each physical machine
- Use WSL2 filesystem for SSH keys, not Windows mounts
- Test networking configuration early and thoroughly

### LL-003: Resource Planning for Multi-Machine Setups
**Insight**: Distributed clusters require careful resource allocation planning

**Considerations**:
- Master nodes need more resources (4GB vs 2GB for workers)
- HA requires masters on different physical hosts
- Total cluster resources limited by weakest physical machine

**Implementation**:
- HP Omen: 4 nodes (2 masters + 2 workers) = 12GB allocation
- Toshiba Satellite: 2 workers = 4GB allocation
- Leave headroom for host OS operations (~4GB each machine)

### LL-004: Infrastructure as Code Benefits
**Insight**: Vagrant + Ansible combination provides excellent reproducibility

**Advantages**:
- Entire cluster can be destroyed and recreated in ~15 minutes
- Configuration changes are version-controlled and traceable  
- Documentation stays synchronized with actual implementation
- Multiple team members can deploy identical environments

**Challenges**:
- Initial setup complexity higher than manual configuration
- Debugging requires understanding multiple layers (Vagrant, VirtualBox, Flatcar)
- State management across multiple physical machines

---

## Performance & Optimization

### Resource Utilization Baseline
**Measurement Date**: 2025-07-22  
**Cluster State**: 6 nodes running, Docker inactive, no Kubernetes workloads

| Metric | Master Nodes | Worker Nodes | Total Cluster |
|--------|--------------|--------------|---------------|
| **RAM Usage** | ~500MB each | ~400MB each | ~2.8GB |
| **CPU Load** | 0.00-0.08 | 0.00-0.08 | Very Low |
| **Disk Usage** | 1-2% (16GB) | 1-2% (16GB) | ~1.5GB total |
| **Network** | Minimal | Minimal | Background only |

### Performance Optimizations Applied

**VirtualBox Settings**:
```ruby
# Enable nested virtualization for container performance
vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]

# Use linked clones for disk space efficiency
vb.linked_clone = true

# Optimize memory allocation
vb.memory = "4096"  # Masters
vb.memory = "2048"  # Workers
```

**Flatcar Configuration**:
- Immutable OS reduces filesystem overhead
- systemd-networkd provides efficient networking
- Container-optimized kernel reduces memory footprint

### Expected Performance Under Load
**Kubernetes Workload Capacity** (estimated):
- **Light workloads**: 20-30 pods per worker node
- **Medium workloads**: 10-15 pods per worker node  
- **Resource-intensive**: 5-10 pods per worker node
- **Control plane**: HA setup should handle 100+ node cluster

**Bottlenecks Identified**:
1. **Memory**: Worker nodes limited to 2GB each
2. **Network**: WiFi bandwidth shared across all VMs
3. **Storage**: VirtualBox overhead on spinning disks (Toshiba)

---

## Security Considerations

### SC-001: SSH Key Management
**Implementation**:
- Using Vagrant insecure keys for development cluster
- Keys stored with 600 permissions on WSL2 filesystem
- SSH access restricted to LAN network range

**Production Recommendations**:
- Generate unique SSH key pairs for each environment
- Implement SSH certificate authority for key management
- Use SSH bastion host for external access

### SC-002: Network Segmentation
**Current State**:
- All VMs on main LAN (192.168.0.0/24)
- Direct access from any LAN client
- No firewall rules between cluster nodes

**Security Implications**:
- ✅ **Simplified management**: Direct access for development
- ❌ **Attack surface**: VMs accessible from entire LAN
- ❌ **Lateral movement**: No isolation between cluster components

**Production Recommendations**:
- Create dedicated VLAN for Kubernetes cluster
- Implement network policies within Kubernetes
- Use jump box for external cluster access

### SC-003: Flatcar Linux Security Benefits
**Advantages**:
- **Immutable root filesystem**: Reduces attack persistence
- **Automatic updates**: Security patches applied atomically
- **Minimal package set**: Reduced attack surface
- **Container isolation**: Workloads run in isolated containers

**Limitations**:
- **No host-based security tools**: Limited monitoring/detection
- **Container runtime security**: Depends on Docker/containerd security
- **Network-level attacks**: Host networking still vulnerable

---

## Future Enhancements

### FE-001: Kubernetes Installation & Configuration
**Priority**: High  
**Timeline**: Next 2 weeks

**Components**:
- [ ] Container runtime activation (Docker/containerd)
- [ ] kubeadm, kubelet, kubectl installation
- [ ] HA control plane initialization
- [ ] Worker node joining automation
- [ ] CNI networking (Flannel/Calico)

**Ansible Implementation Strategy**:
- Use raw modules for Flatcar compatibility
- Leverage systemd for service management
- Implement health checks and validation

### FE-002: Monitoring & Observability
**Priority**: Medium  
**Timeline**: 4-6 weeks

**Stack Components**:
- **Prometheus**: Metrics collection and alerting
- **Grafana**: Visualization and dashboards
- **Node Exporter**: Host-level metrics
- **cAdvisor**: Container metrics
- **Loki**: Log aggregation

**Integration Points**:
- Flatcar systemd journal integration
- VirtualBox host metrics collection
- Network performance monitoring

### FE-003: Storage & Persistence
**Priority**: Medium  
**Timeline**: 6-8 weeks

**Options Evaluation**:
- **Local PVs**: Simple, fast, no network dependency
- **NFS**: Shared storage across nodes
- **Longhorn**: Distributed block storage
- **OpenEBS**: Cloud-native storage

**Considerations**:
- VirtualBox disk performance characteristics
- Cross-machine storage replication
- Backup and disaster recovery

### FE-004: CI/CD Integration
**Priority**: Low  
**Timeline**: 8-12 weeks

**Pipeline Components**:
- **GitLab/GitHub Actions**: CI pipeline execution
- **ArgoCD**: GitOps deployment
- **Harbor/Registry**: Container image management
- **Tekton**: Cloud-native pipeline execution

**Integration Strategy**:
- Infrastructure changes via Vagrant/Ansible
- Application deployments via Kubernetes manifests
- Automated testing in cluster environment

### FE-005: Advanced Networking
**Priority**: Low  
**Timeline**: 12+ weeks

**Features**:
- **Service Mesh**: Istio or Linkerd implementation
- **Ingress Controller**: NGINX or Traefik
- **Load Balancing**: MetalLB for bare-metal LoadBalancer
- **DNS**: CoreDNS optimization and custom zones

**Challenges**:
- Limited public IP addresses (residential internet)
- Dynamic DNS for external access
- SSL/TLS certificate management

---

## Change Log

| Date | Version | Changes | Author |
|------|---------|---------|---------|
| 2025-07-22 | 1.0 | Initial engineering notebook creation | Jim |
| 2025-07-22 | 1.1 | Added Ansible raw module solution documentation | Jim |
| 2025-07-28 | 1.2 | Architecture restructure: Single master + resource optimization | Jim |

---

*This engineering notebook serves as a living document capturing the technical journey, decisions, and lessons learned in building a production-ready Kubernetes home lab. Regular updates ensure knowledge preservation and support future architectural decisions.*
