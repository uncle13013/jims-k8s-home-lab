
# Jim's Kubernetes Home Lab

Welcome to my ultimate home lab project! This repository documents the setup, configuration, and experiments for my personal Kubernetes playground, designed for learning, hacking, and building cool stuff.

## Hardware

- **Dell R610 Server**
  - Running Ubuntu Server
  - Hosts KVM virtual machines
- **Toshiba Satellite Laptop**
  - Connected via WiFi
  - Runs VirtualBox/Vagrant for easy VM management

## Virtualization & OS

- **KVM VMs on Dell R610:**
  - [Flatcar Linux](https://www.flatcar.org/) (Kubernetes nodes)
  - [Kali Linux](https://www.kali.org/) (Security testing, outside the cluster)
- **VirtualBox/Vagrant on Toshiba Satellite:**
  - Additional Kubernetes nodes (Flatcar or other distros)
  - Chosen for WiFi compatibility and flexibility

## Kubernetes Cluster

- Multi-node cluster spanning KVM and VirtualBox VMs
- Mix of Flatcar Linux nodes for reliability and security
- Networked across physical and virtual machines

## Projects & Experiments

- **Trivia Game**
  - Deploy and run a custom trivia game in the cluster
  - Experiment with Kubernetes services, scaling, and networking
- **Vulnerable Linux Containers**
  - Set up intentionally vulnerable containers inside the cluster
  - Use Kali Linux VM (outside the cluster) to attack/test security
- **Service Exploration**
  - Play with various Kubernetes services, ingress, monitoring, and more

## Goals

- Build hands-on experience with Kubernetes, networking, and security
- Learn to automate VM and cluster setup
- Test and improve security skills in a safe environment
- Have fun building, breaking, and fixing things!

---


---

## Local Kubernetes Lab Tutorial (Non-Minikube)

This section is a step-by-step guide for setting up a local Kubernetes environment (not using minikube), perfect for those practicing for KCA/KCS exams or just wanting to learn by doing. The exercises below cover real-world scenarios and cloud-native projects.

### Lab Setup Overview

- Use KVM, VirtualBox, or Vagrant to create VMs running Flatcar, Ubuntu, or other distros
- Install Kubernetes using kubeadm, k3s, or other methods
- Avoid minikube for a more production-like experience

### Hands-On Exercises

1. **Set up CRI-O or containerd with GPU support**
2. **Deploy DeepSeek in Ollama**
3. **Install PyTorch and run a Jupyter Notebook server**
4. **Configure persistent storage (e.g., local PVs, NFS, Longhorn)**
5. **Add k8sgpt with DeepSeek backend via Ollama**
6. **Install and experiment with Istio service mesh**
7. **(Optional) Add a node in AWS or set up a separate k3s cluster in the cloud**
8. **Set up metrics collection (Prometheus, etc.)**
    - Gather system metrics for all cluster components
    - Integrate IoT devices and collect their metrics
    - Periodically test internet speed
    - Monitor service uptime
    - Run a headless Kodi and trigger DB refreshes on new downloads
9. **Set up Splunk logging (dev version)**
10. **Install SonarQube for code quality analysis**
11. **Configure TLS with Let's Encrypt and expose a public service (use dynamic DNS if needed)**
12. **Explore more cloud-native projects:**
    - Graduated: Argo CI/CD, CRI-O, cert-manager, Helm, Istio, Prometheus, SPIFFE/SPIRE, TUF
    - Experimental: Chaos engineering, Dragonfly container registry, Kubeflow
13. **Set up a VPN for secure remote monitoring and management**

### Why This Lab?

- Practice for Kubernetes exams (KCA/KCS) with real-world scenarios
- Build and break things in a safe, local environment
- Explore advanced cloud-native tools and integrations

---

Stay tuned for detailed setup guides, configs, and walkthroughs for each exercise!
