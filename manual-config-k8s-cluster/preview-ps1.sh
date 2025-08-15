#!/bin/bash

echo "Preview of Kubernetes Node PS1 Prompts"
echo "======================================"
echo ""

echo "🚀 MASTER NODE PROMPT:"
echo "Colors: Red username, Green hostname, Blue path"
MASTER_PS1='\[\033[01;31m\]\u\[\033[01;33m\]@\[\033[01;32m\]\h\[\033[01;34m\]:\[\033[01;35m\]\w\[\033[01;36m\]\$\[\033[00m\] '
export PS1="$MASTER_PS1"
echo ""

echo "⚡ WORKER NODE PROMPT:"
echo "Colors: Green username, Red hostname, Blue path"
WORKER_PS1='\[\033[01;32m\]\u\[\033[01;33m\]@\[\033[01;31m\]\h\[\033[01;34m\]:\[\033[01;35m\]\w\[\033[01;36m\]\$\[\033[00m\] '
export PS1="$WORKER_PS1"
echo ""

echo "Session indicators that will appear on login:"
echo ""
echo "Master Node:"
echo "🚀 Kubernetes Master Node - k8s-master"
echo "📍 IP: 192.168.0.240"
echo "⏰ $(date)"
echo ""
echo "Worker Node:"
echo "⚡ Kubernetes Worker Node - k8s-worker"
echo "📍 IP: 192.168.0.241"
echo "⏰ $(date)"
echo ""

echo "To apply these prompts:"
echo "1. Copy the scripts to each VM"
echo "2. Run ./master-ps1-config.sh on master"
echo "3. Run ./worker-ps1-config.sh on worker"
echo "4. Restart shell or run 'source ~/.bashrc'" 