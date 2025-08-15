# Exercise 1: Cluster Health Verification

**Domain**: Cluster Architecture, Installation & Configuration (25%)  
**Time**: 45 minutes  
**Difficulty**: Beginner  

## 🎯 Objective

Verify and understand your existing 2-node Kubernetes cluster with kubeadm and Calico CNI, demonstrating the fundamental skills needed for the CKA exam.

## 📋 Prerequisites

- Running 2-node Kubernetes cluster with kubeadm and Calico CNI
- kubectl configured and working
- Basic Linux command line knowledge

## 🚀 Step-by-Step Instructions

### Step 1: Cluster Status Verification

1. **Verify your cluster is running**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

2. **Check cluster information**:
   ```bash
   kubectl cluster-info
   kubectl get componentstatuses
   ```

3. **Verify system components**:
   ```bash
   # Check control plane pods
   kubectl get pods -n kube-system -l tier=control-plane
   
   # Check Calico CNI pods
   kubectl get pods -n kube-system -l k8s-app=calico-node
   
   # Check cluster version
   kubectl version --short
   ```

### Step 2: Container Runtime Verification

1. **Check container runtime status**:
   ```bash
   # Check if containerd is running on nodes
   kubectl get nodes -o wide
   
   # Check runtime information
   kubectl describe node master-1 | grep -A 5 "System Info"
   ```

2. **Verify runtime configuration**:
   ```bash
   # Check runtime version
   kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.containerRuntimeVersion}'
   
   # Check runtime endpoint
   kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.containerRuntimeVersion}'
   ```

### Step 3: Kubernetes Components Verification

1. **Check Kubernetes component versions**:
   ```bash
   # Check kubectl version
   kubectl version --client
   
   # Check cluster version
   kubectl version --short
   
   # Check kubelet version on nodes
   kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.kubeletVersion}'
   ```

2. **Verify component status**:
   ```bash
   # Check all component statuses
   kubectl get componentstatuses
   
   # Check specific components
   kubectl get componentstatuses scheduler
   kubectl get componentstatuses controller-manager
   kubectl get componentstatuses etcd-0
   ```

### Step 4: Control Plane Verification

1. **Check control plane status**:
   ```bash
   # Check control plane pods
   kubectl get pods -n kube-system -l tier=control-plane
   
   # Check control plane node
   kubectl get nodes -l node-role.kubernetes.io/control-plane
   
   # Check API server endpoints
   kubectl get endpoints -n default kubernetes
   ```

2. **Verify control plane configuration**:
   ```bash
   # Check kubeadm configuration
   kubectl get configmap -n kube-system kubeadm-config -o yaml
   
   # Check cluster configuration
   kubectl cluster-info dump | grep -A 10 "kubeadm"
   ```

3. **Verify control plane is healthy**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

### Step 5: Calico CNI Verification

1. **Check Calico CNI status**:
   ```bash
   # Check Calico pods
   kubectl get pods -n kube-system -l k8s-app=calico-node
   kubectl get pods -n kube-system -l k8s-app=calico-kube-controllers
   
   # Check Calico daemon set
   kubectl get daemonset -n kube-system calico-node
   ```

2. **Verify Calico configuration**:
   ```bash
   # Check Calico configuration
   kubectl get configmap -n kube-system calico-config -o yaml
   
   # Check Calico logs
   kubectl logs -n kube-system -l k8s-app=calico-node --tail=10
   ```

### Step 6: Worker Node Verification

1. **Check worker node status**:
   ```bash
   # Check worker nodes
   kubectl get nodes -l '!node-role.kubernetes.io/control-plane'
   
   # Check worker node details
   kubectl describe node worker-1
   
   # Check node labels and roles
   kubectl get nodes --show-labels
   ```

2. **Verify worker node connectivity**:
   ```bash
   # Check if worker can communicate with control plane
   kubectl get endpoints -n default kubernetes
   
   # Check node taints and tolerations
   kubectl get nodes -o jsonpath='{.items[*].spec.taints}'
   ```

### Step 7: Cluster Functionality Test

1. **Test cluster functionality**:
   ```bash
   # Create a test pod
   kubectl run nginx --image=nginx --port=80
   
   # Check pod status
   kubectl get pods
   
   # Test pod connectivity
   kubectl exec -it nginx -- curl localhost
   
   # Clean up test pod
   kubectl delete pod nginx
   ```

2. **Verify cluster networking**:
   ```bash
   # Check service endpoints
   kubectl get endpoints --all-namespaces
   
   # Check network policies
   kubectl get networkpolicies --all-namespaces
   
   # Check Calico network status
   kubectl get pods -n kube-system -l k8s-app=calico-node -o wide
   ```

## ✅ Success Criteria

- [ ] Both nodes show as Ready in `kubectl get nodes`
- [ ] All system pods are Running in kube-system namespace
- [ ] Calico CNI pods are Running
- [ ] Test pod can be created and accessed
- [ ] Cluster networking is functional
- [ ] Control plane components are healthy

## 🔍 Troubleshooting Tips

### Common Issues

1. **Calico CNI not ready**: Check Calico pods and configuration
2. **Node not ready**: Check kubelet status and node conditions
3. **Pod scheduling issues**: Verify taints and tolerations
4. **Network connectivity**: Check Calico network policies and BGP status

### Useful Commands

```bash
# Check node status
kubectl describe node <node-name>

# Check pod events
kubectl describe pod <pod-name> -n <namespace>

# Check cluster info
kubectl cluster-info

# Check component status
kubectl get componentstatuses
```

## 📚 Next Steps

After completing this exercise:
1. **Practice cluster operations**: scaling, upgrading, maintenance
2. **Move to Exercise 2**: Cluster Lifecycle Management
3. **Explore kubectl commands**: get, describe, logs, exec
4. **Study cluster architecture**: understand the components in your running cluster

## ⏰ Time Management

- **Cluster status verification**: 10 minutes
- **Runtime verification**: 10 minutes
- **Component verification**: 10 minutes
- **Control plane verification**: 10 minutes
- **CNI and networking verification**: 5 minutes

**Total**: 45 minutes (matches exam time allocation for this domain)

---

*Remember: This is the foundation for everything else. Take your time to understand what each component in your running cluster does!*
