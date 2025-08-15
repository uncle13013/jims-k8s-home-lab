#!/bin/bash

echo "Configuring simple cyan PS1 prompt for Kubernetes Worker Node..."

# Create a simple cyan PS1 for the worker node with timestamp
WORKER_PS1='\[\033[01;36m\][\t] \u@\h:\w\$\[\033[00m\] '

# Add to .bashrc if not already present
if ! grep -q "WORKER_PS1" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Kubernetes Worker Node PS1" >> ~/.bashrc
    echo "export PS1='$WORKER_PS1'" >> ~/.bashrc
fi

# Apply immediately for current session
export PS1='\[\033[01;36m\][\t] \u@\h:\w\$\[\033[00m\] '

echo "Worker node PS1 configured!"
echo "Current prompt should now show in cyan with timestamp"
echo "Format: [HH:MM:SS] user@host:path$" 