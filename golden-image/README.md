# Flatcar Linux + Kubernetes Configuration

This directory contains the proper **Ignition/Butane** configuration approach for Flatcar Linux, which is the standard way to configure Flatcar systems.

## Flatcar Configuration Overview

**Flatcar Linux** uses a declarative configuration system:

1. **Butane** (`.bu` files) - Human-readable YAML configuration
2. **Ignition** (`.ign` files) - JSON configuration consumed by Flatcar on first boot
3. **First Boot** - Ignition runs once during initial system startup

This is much more reliable than shell scripts because it's:
- **Declarative**: You specify the desired state, not the steps
- **Atomic**: All changes happen during first boot or not at all
- **Immutable**: Configuration is baked into the system image

## Files Explained

### `kubernetes.bu` (Butane Configuration)
Human-readable YAML that defines:
- User accounts and permissions
- File system layout and files
- Systemd services and configuration
- Kernel modules and sysctl parameters
- Docker daemon configuration
- Kubernetes binary installation

### `kubernetes.ign` (Ignition JSON)
Generated from Butane config - this is what Flatcar actually consumes on first boot.

### `convert-butane.sh`
Script to convert `.bu` → `.ign` using the `butane` tool.

## Installation Requirements

You need the **butane** tool to convert configurations:

```bash
# Download butane (latest version)
wget https://github.com/coreos/butane/releases/download/v0.19.0/butane-x86_64-unknown-linux-gnu -O /tmp/butane
sudo mv /tmp/butane /usr/local/bin/butane
sudo chmod +x /usr/local/bin/butane
```

## Usage Workflow

### 1. Edit Butane Configuration
Modify `kubernetes.bu` with your desired configuration:

```yaml
variant: flatcar
version: 1.0.0
passwd:
  users:
    - name: core
      groups: [docker, sudo]
storage:
  files:
    - path: /etc/docker/daemon.json
      contents:
        inline: |
          {"exec-opts": ["native.cgroupdriver=systemd"]}
```

### 2. Convert to Ignition
```bash
./convert-butane.sh
```

This generates `kubernetes.ign` from `kubernetes.bu`.

### 3. Use with Vagrant
The Vagrantfile automatically provisions using the Ignition config:

```ruby
# Copy Ignition config to VM
master1.vm.provision "file", 
  source: "../../golden-image/kubernetes.ign", 
  destination: "/tmp/kubernetes.ign"

# Apply configuration (fallback script)
master1.vm.provision "shell", 
  path: "../../golden-image/setup-k8s-prerequisites.sh"
```

## What Gets Configured

The Butane/Ignition config sets up:

### ✅ Container Runtime
- Docker daemon with systemd cgroup driver
- Containerd service enabled
- User permissions for docker group

### ✅ Kubernetes Prerequisites  
- Downloads kubelet, kubeadm, kubectl (v1.28.2)
- Installs CNI plugins (v1.3.0)
- Creates required directories (`/etc/kubernetes`, `/var/lib/kubelet`, etc.)

### ✅ System Configuration
- Kernel modules: `overlay`, `br_netfilter`
- Sysctl parameters for networking
- Systemd services for all components

### ✅ Path Configuration
- Adds `/opt/bin` to system PATH
- Configures kubelet systemd service with proper arguments

## Advantages Over Shell Scripts

| Shell Scripts | Ignition/Butane |
|---------------|-----------------|
| ❌ Imperative (how) | ✅ Declarative (what) |
| ❌ Run every boot | ✅ One-time first boot |
| ❌ Can fail partially | ✅ Atomic success/failure |
| ❌ Mutable changes | ✅ Immutable configuration |
| ❌ Hard to debug | ✅ Clear validation |

## Integration with Kubernetes

After Ignition configures the system:

### Initialize Master Node
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

### Join Worker Nodes
```bash
sudo kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash <hash>
```

### Install CNI Plugin
```bash
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

## Troubleshooting

### Check Ignition Logs
```bash
journalctl -u ignition-firstboot-complete
```

### Validate Butane Syntax
```bash
butane --strict < kubernetes.bu > /dev/null
```

### Check Downloaded Binaries
```bash
ls -la /opt/bin/
/opt/bin/kubelet --version
```

This approach follows Flatcar Linux best practices and provides a more reliable, maintainable configuration than traditional shell scripts.
