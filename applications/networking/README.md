# Services & Networking Practice - CKA Domain 3 (20%)

This directory contains practical exercises for **Services & Networking** - covering pod connectivity, service types, network policies, and traffic management.

## 🎯 Learning Objectives

- Pod-to-pod connectivity and communication
- Service types (ClusterIP, NodePort, LoadBalancer)
- Endpoints and service discovery
- Network Policies for pod isolation
- Gateway API implementation
- Ingress controllers and resources
- CoreDNS configuration and troubleshooting

## 📋 Exercise Checklist

### Exercise 1: Basic Service Communication
- [ ] Deploy multiple pods
- [ ] Create ClusterIP services
- [ ] Test pod-to-pod communication
- [ ] Understand service discovery

### Exercise 2: Service Types Deep Dive
- [ ] ClusterIP services (internal communication)
- [ ] NodePort services (external access)
- [ ] LoadBalancer services (cloud integration)
- [ ] Headless services (direct pod access)

### Exercise 3: Network Policies
- [ ] Default deny policies
- [ ] Allow specific traffic
- [ ] Pod isolation strategies
- [ ] Policy troubleshooting

### Exercise 4: Ingress & Gateway API
- [ ] Install Ingress controller
- [ ] Configure Ingress resources
- [ ] SSL/TLS termination
- [ ] Path-based routing

### Exercise 5: CoreDNS & Service Discovery
- [ ] CoreDNS configuration
- [ ] Custom DNS entries
- [ ] Service name resolution
- [ ] DNS troubleshooting

### Exercise 6: Advanced Networking
- [ ] Multi-cluster communication
- [ ] Network segmentation
- [ ] Traffic shaping
- [ ] Network monitoring

## 🚀 Quick Start

1. **Ensure your cluster is running**:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

2. **Start with Exercise 1** - Basic Service Communication

3. **Practice each networking concept** with real applications

## 📚 Reference Materials

- [Services documentation](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [CoreDNS](https://coredns.io/)

## ⚠️ Important Notes

- **Start with basic services** before advanced networking
- **Understand the different service types** and when to use each
- **Practice Network Policies** - they're commonly tested
- **Learn to troubleshoot** service connectivity issues
- **Focus on Ingress** - it's a key exam topic
