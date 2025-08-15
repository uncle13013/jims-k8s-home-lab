#!/bin/bash

echo "Configuring simple red PS1 prompt for Kubernetes Master Node..."

# Create a simple red PS1 for the master node with timestamp
MASTER_PS1='\[\033[01;31m\][\t] \u@\h:\w\$\[\033[00m\] '

# Add to .bashrc if not already present
if ! grep -q "MASTER_PS1" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Kubernetes Master Node PS1" >> ~/.bashrc
    echo "export PS1='$MASTER_PS1'" >> ~/.bashrc
fi

# Apply immediately for current session
export PS1='\[\033[01;31m\][\t] \u@\h:\w\$\[\033[00m\] '

echo "Master node PS1 configured!"
echo "Current prompt should now show in red with timestamp"
echo "Format: [HH:MM:SS] user@host:path$" 