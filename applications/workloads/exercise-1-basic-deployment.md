# Exercise 1: Basic Application Deployment

**Domain**: Workloads & Scheduling (15%)  
**Time**: 27 minutes  
**Difficulty**: Beginner  

## 🎯 Objective

Learn the fundamentals of deploying and managing applications in Kubernetes, including different deployment methods and basic lifecycle management.

## 📋 Prerequisites

- Running Kubernetes cluster (from Infrastructure Exercise 1)
- kubectl configured and working
- Basic understanding of YAML syntax

## 🚀 Step-by-Step Instructions

### Step 1: Understanding Deployment Methods

1. **Check your cluster status**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

2. **Create a namespace for practice**:
   ```bash
   kubectl create namespace workload-practice
   kubectl get namespaces
   ```

### Step 2: Imperative Deployment (kubectl run)

1. **Deploy nginx using kubectl run**:
   ```bash
   kubectl run nginx-imperative --image=nginx:1.25 --port=80 -n workload-practice
   ```

2. **Check the deployment**:
   ```bash
   kubectl get pods -n workload-practice
   kubectl get deployments -n workload-practice
   ```

3. **Understand what was created**:
   ```bash
   # Check the deployment object
   kubectl get deployment nginx-imperative -n workload-practice -o yaml
   
   # Check the pod details
   kubectl describe pod -l run=nginx-imperative -n workload-practice
   ```

### Step 3: Declarative Deployment (YAML)

1. **Create a deployment YAML file**:
   ```bash
   cat <<EOF > nginx-deployment.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-declarative
     namespace: workload-practice
     labels:
       app: nginx
       version: v1
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: nginx
     template:
       metadata:
         labels:
           app: nginx
           version: v1
       spec:
         containers:
         - name: nginx
           image: nginx:1.25
           ports:
           - containerPort: 80
           resources:
             requests:
               memory: "64Mi"
               cpu: "250m"
             limits:
               memory: "128Mi"
               cpu: "500m"
   EOF
   ```

2. **Apply the deployment**:
   ```bash
   kubectl apply -f nginx-deployment.yaml
   ```

3. **Verify the deployment**:
   ```bash
   kubectl get pods -n workload-practice
   kubectl get deployments -n workload-practice
   ```

### Step 4: Pod Lifecycle Management

1. **Scale the deployment**:
   ```bash
   # Scale up to 5 replicas
   kubectl scale deployment nginx-declarative --replicas=5 -n workload-practice
   
   # Check the result
   kubectl get pods -n workload-practice
   ```

2. **Scale down to 2 replicas**:
   ```bash
   kubectl scale deployment nginx-declarative --replicas=2 -n workload-practice
   kubectl get pods -n workload-practice
   ```

3. **Delete a pod and watch it recreate**:
   ```bash
   # Get a pod name
   POD_NAME=$(kubectl get pods -n workload-practice -l app=nginx -o jsonpath='{.items[0].metadata.name}')
   
   # Delete the pod
   kubectl delete pod $POD_NAME -n workload-practice
   
   # Watch it recreate
   kubectl get pods -n workload-practice -w
   # Press Ctrl+C when you see the new pod
   ```

### Step 5: Application Interaction

1. **Port forward to access the application**:
   ```bash
   # Port forward in background
   kubectl port-forward deployment/nginx-declarative 8080:80 -n workload-practice &
   
   # Test the connection
   curl localhost:8080
   
   # Stop port forwarding
   kill %1
   ```

2. **Execute commands in the container**:
   ```bash
   # Get a pod name
   POD_NAME=$(kubectl get pods -n workload-practice -l app=nginx -o jsonpath='{.items[0].metadata.name}')
   
   # Execute a command
   kubectl exec -it $POD_NAME -n workload-practice -- nginx -v
   
   # Check container logs
   kubectl logs $POD_NAME -n workload-practice
   ```

### Step 6: Cleanup and Comparison

1. **Compare the two deployment methods**:
   ```bash
   # Check what was created by kubectl run
   kubectl get all -n workload-practice -l run=nginx-imperative
   
   # Check what was created by YAML
   kubectl get all -n workload-practice -l app=nginx
   ```

2. **Clean up**:
   ```bash
   # Delete the imperative deployment
   kubectl delete deployment nginx-imperative -n workload-practice
   
   # Delete the declarative deployment
   kubectl delete -f nginx-deployment.yaml
   
   # Delete the namespace
   kubectl delete namespace workload-practice
   ```

## ✅ Success Criteria

- [ ] Successfully deployed applications using both methods
- [ ] Understood the difference between imperative and declarative approaches
- [ ] Successfully scaled deployments up and down
- [ ] Observed pod recreation after deletion
- [ ] Successfully interacted with running applications
- [ ] Cleaned up all resources

## 🔍 Key Concepts Learned

### Imperative vs Declarative
- **Imperative**: `kubectl run` - quick for testing, less control
- **Declarative**: YAML files - production-ready, version controlled

### Deployment Objects
- **Deployment**: Manages ReplicaSets and provides rolling updates
- **ReplicaSet**: Ensures desired number of pods are running
- **Pod**: Smallest deployable unit in Kubernetes

### Resource Management
- **Requests**: Minimum resources guaranteed to the pod
- **Limits**: Maximum resources the pod can use

## 📚 Next Steps

After completing this exercise:
1. **Practice with different images**: Try busybox, httpd, or custom images
2. **Experiment with different resource limits**: See how pods behave under constraints
3. **Move to Exercise 2**: Multi-tier Application
4. **Learn about other controllers**: DaemonSet, StatefulSet, Job

## ⏰ Time Management

- **Understanding deployment methods**: 5 minutes
- **Imperative deployment**: 5 minutes
- **Declarative deployment**: 8 minutes
- **Lifecycle management**: 5 minutes
- **Application interaction**: 3 minutes
- **Cleanup and comparison**: 1 minute

**Total**: 27 minutes (matches exam time allocation for this domain)

## 🎯 Exam Tips

- **Know the difference** between imperative and declarative approaches
- **Understand resource requests vs limits** - this is commonly tested
- **Practice scaling operations** - they're quick points on the exam
- **Learn to read YAML** - you'll need to edit existing manifests

---

*Remember: Deployments are the foundation of application management in Kubernetes. Master this before moving to advanced topics!*
