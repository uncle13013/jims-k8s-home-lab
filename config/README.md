# Development Configuration

This directory contains configuration files for development tools used in the Kubernetes home lab project.

## Tmux Configuration

### Overview
The `tmux.conf` file provides an enhanced tmux experience optimized for Kubernetes development and cluster management.

### Key Features

#### 🖱️ Mouse Support
- **Mouse resizing**: Click and drag pane borders to resize
- **Mouse selection**: Click to select panes
- **Mouse scrolling**: Scroll through terminal history
- **Mouse copy/paste**: Select text with mouse and copy to clipboard

#### ⌨️ Enhanced Keyboard Shortcuts

##### Pane Management
- **`|`** - Split pane horizontally
- **`-`** - Split pane vertically
- **`Alt + Arrow`** - Switch between panes (no prefix needed)
- **`Ctrl + Arrow`** - Resize panes by 5 units
- **`Ctrl+b + Arrow`** - Switch panes (traditional)

##### Window Management
- **`Ctrl + h`** - Switch to previous window
- **`Ctrl + l`** - Switch to next window
- **`Ctrl+b + c`** - Create new window
- **`Ctrl+b + ,`** - Rename current window
- **`Ctrl+b + n`** - Next window
- **`Ctrl+b + p`** - Previous window

##### Utility Commands
- **`r`** - Reload tmux configuration
- **`e`** - Edit tmux config in new window
- **`y`** - Synchronize panes (run same command in all panes)

#### 🎨 Visual Enhancements
- **Status bar** with session name, load average, and time
- **Color-coded** panes and windows
- **Activity monitoring** - highlights windows with activity
- **Large scrollback** buffer (10,000 lines)
- **Vi mode** for copy/paste operations

### Installation

#### 1. Copy Configuration
```bash
# Copy to your home directory
cp config/tmux.conf ~/.tmux.conf

# Or create a symlink
ln -s $(pwd)/config/tmux.conf ~/.tmux.conf
```

#### 2. Install Tmux Plugin Manager (Optional)
```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux and install plugins
tmux
# Then press Ctrl+b + I (capital i) to install plugins
```

### Usage Examples

#### Kubernetes Cluster Management
```bash
# Create a new tmux session for cluster work
tmux new-session -s k8s-cluster

# Split into multiple panes for different nodes
# Pane 1: Master node
ssh m

# Pane 2: Worker node  
ssh w

# Synchronize panes to run same command on both
# Press 'y' to sync, then run commands
kubectl get nodes
```

#### Development Workflow
```bash
# Window 1: Code editing
vim

# Window 2: Terminal for commands
# Window 3: Log monitoring
tail -f /var/log/kubelet.log

# Window 4: Documentation
# Window 5: Testing
```

### Copy/Paste Operations

#### Using Mouse
1. Enter copy mode: `Ctrl+b + [`
2. Click and drag to select text
3. Press `Enter` to copy to clipboard
4. Right-click to paste

#### Using Keyboard (Vi Mode)
1. Enter copy mode: `Ctrl+b + [`
2. Use `v` to start selection
3. Use arrow keys to select text
4. Press `y` to copy
5. Press `Enter` to exit copy mode
6. Right-click to paste

### Session Management

#### Create and Attach
```bash
# Create new session
tmux new-session -s session-name

# Attach to existing session
tmux attach -t session-name

# List all sessions
tmux list-sessions
```

#### Detach and Reattach
```bash
# Detach from session (keeps it running)
Ctrl+b + d

# Reattach to session
tmux attach -t session-name
```

### Plugin Features (if TPM installed)

#### tmux-resurrect
- **Save session**: `Ctrl+b + Ctrl+s`
- **Restore session**: `Ctrl+b + Ctrl+r`
- Automatically saves and restores tmux sessions

#### tmux-continuum
- Automatic session saving every 15 minutes
- Automatic session restoration on tmux start

### Troubleshooting

#### Mouse Not Working
```bash
# Check if mouse is enabled
tmux show-options -g mouse

# Enable manually if needed
tmux set-option -g mouse on
```

#### Colors Not Displaying
```bash
# Check terminal support
echo $TERM

# Set terminal type
export TERM=screen-256color
```

#### Copy/Paste Issues
```bash
# Install xclip if not available
sudo apt install xclip

# Or use xsel as alternative
sudo apt install xsel
```

### Customization

#### Add Custom Key Bindings
```bash
# Add to ~/.tmux.conf
bind-key -n F1 new-window -n "logs" "tail -f /var/log/kubelet.log"
bind-key -n F2 new-window -n "kubectl" "kubectl get pods --watch"
```

#### Change Colors
```bash
# Modify color settings in ~/.tmux.conf
set -g status-style bg=blue,fg=white
set -g pane-active-border-style fg=green
```

### Integration with Kubernetes Workflow

#### Recommended Session Structure
```
Session: k8s-cluster
├── Window 1: Master Node (ssh m)
├── Window 2: Worker Node (ssh w)  
├── Window 3: kubectl commands
├── Window 4: Log monitoring
└── Window 5: Documentation/notes
```

#### Synchronized Commands
```bash
# Enable pane synchronization
# Press 'y' then run:
kubectl get nodes
kubectl get pods --all-namespaces
systemctl status kubelet
```

This tmux configuration provides a powerful, efficient environment for managing Kubernetes clusters and development workflows. 