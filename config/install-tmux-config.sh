#!/bin/bash

echo "Installing tmux configuration for Kubernetes development..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy tmux configuration
echo "Copying tmux configuration..."
cp "$SCRIPT_DIR/tmux.conf" ~/.tmux.conf

echo "Tmux configuration installed!"
echo ""
echo "To use the new configuration:"
echo "1. Start tmux: tmux"
echo "2. Reload config: Press 'r' (if already in tmux)"
echo "3. Or restart tmux completely"
echo ""
echo "Key features enabled:"
echo "- Mouse support (click to select, drag to resize)"
echo "- Enhanced keyboard shortcuts"
echo "- Status bar with system info"
echo "- Large scrollback buffer"
echo ""
echo "For full documentation, see: $SCRIPT_DIR/README.md" 