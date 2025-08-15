# Troubleshooting Practice - CKA Domain 5 (30%)

This directory contains practical exercises for **Troubleshooting** - the highest weighted domain on the CKA exam, covering cluster, node, and application problem resolution.

## 🎯 Learning Objectives

- Cluster and node troubleshooting
- Component-level debugging
- Application and service troubleshooting
- Resource monitoring and analysis
- Log analysis and debugging
- Performance optimization

## 📋 Exercise Checklist

### Exercise 1: Cluster Component Troubleshooting
- [ ] Control plane component issues
- [ ] etcd cluster problems
- [ ] API server connectivity
- [ ] Scheduler and controller issues

### Exercise 2: Node Troubleshooting
- [ ] Node not ready status
- [ ] Resource exhaustion
- [ ] Network connectivity issues
- [ ] Container runtime problems

### Exercise 3: Pod and Application Issues
- [ ] Pod startup failures
- [ ] Container crashes
- [ ] Resource constraints
- [ ] Configuration problems

### Exercise 4: Service and Networking Problems
- [ ] Service connectivity issues
- [ ] Network policy conflicts
- [ ] DNS resolution problems
- [ ] Ingress routing issues

### Exercise 5: Storage and Volume Issues
- [ ] Volume mount failures
- [ ] Storage class problems
- [ ] Permission and access issues
- [ ] Data persistence problems

### Exercise 6: Performance and Monitoring
- [ ] Resource utilization analysis
- [ ] Performance bottlenecks
- [ ] Monitoring stack setup
- [ ] Alerting and debugging

## 🚀 Quick Start

1. **Ensure your cluster is running**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

2. **Start with Exercise 1** - Cluster Component Troubleshooting

3. **Practice breaking things** and then fixing them

## 📚 Reference Materials

- [Troubleshooting guide](https://kubernetes.io/docs/tasks/debug/)
- [Debugging applications](https://kubernetes.io/docs/tasks/debug-application-cluster/)
- [Node troubleshooting](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/)
- [Logging architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)

## ⚠️ Important Notes

- **This is 30% of the exam** - focus heavily on troubleshooting
- **Practice breaking things** - create problems to solve
- **Learn systematic approaches** - don't guess randomly
- **Master kubectl commands** - they're your primary tools
- **Understand error messages** - they often contain the solution
- **Time your practice** - troubleshooting is time-sensitive on the exam

## 🎯 Exam Strategy

### Time Allocation (30% = 54 minutes)
- **Quick diagnosis**: 10 minutes
- **Root cause analysis**: 20 minutes
- **Solution implementation**: 20 minutes
- **Verification**: 4 minutes

### Common Troubleshooting Flow
1. **Check status** - `kubectl get` and `kubectl describe`
2. **Check logs** - `kubectl logs` and component logs
3. **Check events** - `kubectl get events`
4. **Check resources** - CPU, memory, disk, network
5. **Check configuration** - YAML validation and settings
6. **Implement fix** - apply the solution
7. **Verify** - confirm the problem is resolved

### Key Commands to Master
- `kubectl describe` - detailed object information
- `kubectl logs` - container and component logs
- `kubectl exec` - execute commands in containers
- `kubectl get events` - cluster events and errors
- `kubectl top` - resource usage monitoring
- `kubectl explain` - API documentation
