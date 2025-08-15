# Exercise 1: Cluster Component Troubleshooting

**Domain**: Troubleshooting (30%)  
**Time**: 54 minutes  
**Difficulty**: Intermediate  

## 🎯 Objective

Learn systematic approaches to troubleshoot Kubernetes cluster components, including control plane issues, etcd problems, and API server connectivity.

## 📋 Prerequisites

- Running Kubernetes cluster (from Infrastructure Exercise 1)
- kubectl configured and working
- Basic understanding of cluster architecture

## 🚀 Step-by-Step Instructions

### Step 1: Understanding the Troubleshooting Flow

1. **Check cluster status**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   kubectl cluster-info
   ```

2. **Understand the troubleshooting methodology**:
   - **Observe**: What's the current state?
   - **Hypothesize**: What could be wrong?
   - **Test**: Verify your hypothesis
   - **Fix**: Implement the solution
   - **Verify**: Confirm the fix worked

### Step 2: Control Plane Component Analysis

1. **Check control plane components**:
   ```bash
   # Check component status
   kubectl get componentstatuses
   
   # Check control plane pods
   kubectl get pods -n kube-system -l tier=control-plane
   
   # Check control plane node
   kubectl describe node master-1
   ```

2. **Analyze API server**:
   ```bash
   # Check API server pod
   kubectl get pods -n kube-system -l component=kube-apiserver
   
   # Check API server logs
   kubectl logs -n kube-system -l component=kube-apiserver --tail=50
   
   # Check API server endpoints
   kubectl get endpoints -n default kubernetes
   ```

3. **Check scheduler and controller manager**:
   ```bash
   # Check scheduler
   kubectl get pods -n kube-system -l component=kube-scheduler
   kubectl logs -n kube-system -l component=kube-scheduler --tail=20
   
   # Check controller manager
   kubectl get pods -n kube-system -l component=kube-controller-manager
   kubectl logs -n kube-system -l component=kube-controller-manager --tail=20
   ```

### Step 3: etcd Cluster Troubleshooting

1. **Check etcd status**:
   ```bash
   # Check etcd pod
   kubectl get pods -n kube-system -l component=etcd
   
   # Check etcd logs
   kubectl logs -n kube-system -l component=etcd --tail=30
   
   # Check etcd health from inside the pod
   kubectl exec -n kube-system -it etcd-master-1 -- etcdctl member list
   kubectl exec -n kube-system -it etcd-master-1 -- etcdctl endpoint health
   ```

2. **Verify etcd data**:
   ```bash
   # Check etcd data directory
   kubectl exec -n kube-system -it etcd-master-1 -- ls -la /var/lib/etcd
   
   # Check etcd configuration
   kubectl exec -n kube-system -it etcd-master-1 -- cat /etc/kubernetes/manifests/etcd.yaml
   ```

### Step 4: Network and Connectivity Issues

1. **Check cluster networking**:
   ```bash
   # Check CNI pods
   kubectl get pods -n kube-system -l app=flannel
   
   # Check CNI logs
   kubectl logs -n kube-system -l app=flannel --tail=20
   
   # Check network policies
   kubectl get networkpolicies --all-namespaces
   ```

2. **Test pod-to-pod connectivity**:
   ```bash
   # Create test pods
   kubectl run test-pod-1 --image=busybox -- sleep 3600
   kubectl run test-pod-2 --image=busybox -- sleep 3600
   
   # Wait for pods to be ready
   kubectl wait --for=condition=Ready pod/test-pod-1
   kubectl wait --for=condition=Ready pod/test-pod-2
   
   # Test connectivity
   kubectl exec test-pod-1 -- ping -c 3 test-pod-2
   ```

### Step 5: Resource and Performance Issues

1. **Check resource usage**:
   ```bash
   # Check node resources
   kubectl top nodes
   
   # Check pod resources
   kubectl top pods --all-namespaces
   
   # Check resource quotas
   kubectl get resourcequota --all-namespaces
   ```

2. **Analyze resource constraints**:
   ```bash
   # Check node capacity and allocatable
   kubectl describe node master-1 | grep -A 5 "Capacity\|Allocatable"
   
   # Check pod resource requests and limits
   kubectl get pods --all-namespaces -o custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name,CPU_REQ:.spec.containers[*].resources.requests.cpu,CPU_LIMIT:.spec.containers[*].resources.limits.cpu,MEM_REQ:.spec.containers[*].resources.requests.memory,MEM_LIMIT:.spec.containers[*].resources.limits.memory"
   ```

### Step 6: Common Problem Scenarios

1. **Simulate a control plane issue**:
   ```bash
   # Stop the kubelet service (simulate node failure)
   sudo systemctl stop kubelet
   
   # Check what happens
   kubectl get nodes
   kubectl get pods --all-namespaces
   
   # Restart kubelet
   sudo systemctl start kubelet
   
   # Wait for recovery
   sleep 30
   kubectl get nodes
   ```

2. **Simulate a pod scheduling issue**:
   ```bash
   # Create a pod with resource requests that can't be satisfied
   cat <<EOF > resource-test-pod.yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: resource-test-pod
   spec:
     containers:
     - name: resource-test
       image: nginx
       resources:
         requests:
           memory: "10Gi"
           cpu: "5"
   EOF
   
   kubectl apply -f resource-test-pod.yaml
   
   # Check pod status
   kubectl get pod resource-test-pod
   kubectl describe pod resource-test-pod
   
   # Clean up
   kubectl delete -f resource-test-pod.yaml
   ```

### Step 7: Systematic Troubleshooting Practice

1. **Create a troubleshooting checklist**:
   ```bash
   # Document your troubleshooting process
   cat <<EOF > troubleshooting-checklist.md
   # Cluster Troubleshooting Checklist
   
   ## 1. Initial Assessment
   - [ ] Check cluster status
   - [ ] Verify node readiness
   - [ ] Check system pods
   
   ## 2. Component Analysis
   - [ ] API server status
   - [ ] Scheduler status
   - [ ] Controller manager status
   - [ ] etcd health
   
   ## 3. Network Verification
   - [ ] CNI pods status
   - [ ] Pod-to-pod connectivity
   - [ ] Service endpoints
   
   ## 4. Resource Analysis
   - [ ] Node resource usage
   - [ ] Pod resource constraints
   - [ ] Quotas and limits
   
   ## 5. Log Analysis
   - [ ] Component logs
   - [ ] Application logs
   - [ ] System events
   EOF
   ```

2. **Practice the checklist** on your cluster

## ✅ Success Criteria

- [ ] Successfully analyzed control plane components
- [ ] Understood etcd cluster health
- [ ] Identified common problem patterns
- [ ] Practiced systematic troubleshooting approach
- [ ] Created troubleshooting checklist
- [ ] Simulated and resolved common issues

## 🔍 Key Troubleshooting Commands

### Status and Health
```bash
kubectl get nodes                    # Node status
kubectl get pods --all-namespaces    # Pod status
kubectl get componentstatuses        # Component health
kubectl cluster-info                 # Cluster information
```

### Detailed Analysis
```bash
kubectl describe node <node-name>    # Node details
kubectl describe pod <pod-name>      # Pod details
kubectl describe service <svc-name>  # Service details
```

### Logs and Events
```bash
kubectl logs <pod-name>              # Container logs
kubectl get events                    # Cluster events
kubectl get events --sort-by=.metadata.creationTimestamp  # Chronological events
```

### Resource Monitoring
```bash
kubectl top nodes                     # Node resource usage
kubectl top pods                      # Pod resource usage
kubectl get resourcequota             # Resource quotas
```

## 📚 Next Steps

After completing this exercise:
1. **Practice the troubleshooting checklist** regularly
2. **Create more problem scenarios** to solve
3. **Move to Exercise 2**: Node Troubleshooting
4. **Learn advanced debugging tools**: metrics-server, prometheus
5. **Practice under time pressure** - simulate exam conditions

## ⏰ Time Management

- **Component analysis**: 15 minutes
- **etcd troubleshooting**: 10 minutes
- **Network verification**: 10 minutes
- **Resource analysis**: 10 minutes
- **Problem scenarios**: 5 minutes
- **Checklist creation**: 4 minutes

**Total**: 54 minutes (matches exam time allocation for troubleshooting domain)

## 🎯 Exam Tips

- **Start with status checks** - they're quick and often reveal the problem
- **Use describe commands** - they provide detailed information
- **Check logs systematically** - start with the most relevant component
- **Understand error messages** - they often contain the solution
- **Practice the troubleshooting flow** - observation → hypothesis → test → fix → verify

---

*Remember: Troubleshooting is 30% of the exam. Practice this systematically and regularly!*
