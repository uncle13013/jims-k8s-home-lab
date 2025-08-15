#!/bin/bash

echo "Copying PS1 configuration scripts to Kubernetes nodes..."
echo ""

# Copy to master node
echo "📋 Copying to Master Node (192.168.0.240)..."
scp master-ps1-config.sh nox@192.168.0.240:~/
if [ $? -eq 0 ]; then
    echo "✅ Successfully copied to master"
else
    echo "❌ Failed to copy to master (check if IP is configured)"
fi

echo ""

# Copy to worker node  
echo "📋 Copying to Worker Node (192.168.0.241)..."
scp worker-ps1-config.sh nox@192.168.0.241:~/
if [ $? -eq 0 ]; then
    echo "✅ Successfully copied to worker"
else
    echo "❌ Failed to copy to worker (check if IP is configured)"
fi

echo ""
echo "Next steps:"
echo "1. SSH to master: ssh m"
echo "2. Run: ./master-ps1-config.sh"
echo "3. SSH to worker: ssh w" 
echo "4. Run: ./worker-ps1-config.sh"
echo "5. Restart shells or run 'source ~/.bashrc'" 