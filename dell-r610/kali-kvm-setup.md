# Setting Up a Kali Linux KVM VM on Dell R610

This guide walks you through creating a Kali Linux VM using KVM on your Dell R610 server. You can SSH into the server with `ssh dragon`.

## Prerequisites

- SSH access to the server (`ssh dragon`)
- KVM and libvirt installed on the server
- Sufficient disk space and RAM
- Kali Linux ISO (download from [kali.org](https://www.kali.org/get-kali/))

## Automated Setup with Ansible

The setup process has been automated using Ansible. Run the following commands:

```bash
# Run the playbook to set up the Kali Linux VM
ansible-playbook -i inventory.ini setup-kali.yml --ask-become-pass

# Verify the VM is running
ansible dragon -i inventory.ini -m command -a "virsh list --all" --become --ask-become-pass
```

The playbook will:
1. Install required Python modules (lxml)
2. Download the Kali Linux ISO to `/var/lib/libvirt/images/`
3. Create a 20GB disk image for the VM
4. Define the VM with libvirt XML configuration
5. Start the VM

## Getting the VM's IP Address

After the VM is installed and running, you can get its IP address using:

```bash
# Method 1: Check VM network interfaces
ansible dragon -i inventory.ini -m command -a "virsh domifaddr kali-linux" --become --ask-become-pass

# Method 2: Check DHCP leases on the default network
ansible dragon -i inventory.ini -m command -a "virsh net-dhcp-leases default" --become --ask-become-pass

# Method 3: Check using nmap to scan the network
ansible dragon -i inventory.ini -m command -a "nmap -sn 192.168.122.0/24" --become --ask-become-pass
```

Once you have the IP, you can SSH into the Kali VM:
```bash
ssh kali@<vm-ip-address>
```

## Connecting to the VM Console

**Important:** The VM starts with the Kali Linux installer and requires interactive setup. You need to complete the installation before you can get an IP address.

**Console Access Issue:** The VM is configured for VNC graphics only. If you get `cannot find character device <null>` with virsh console, use VNC instead.

### Method 1: VNC Access (Required for this setup)
```bash
# The VM is configured to listen on VNC port 5900 (display :0)
# Connect using a VNC client to: 192.168.0.230:5900
vncviewer 192.168.0.230:5900
```

**VNC Client Options for Windows 11:**
- **TightVNC Viewer** (Recommended): Free, lightweight, simple to use
  - Download from: https://www.tightvnc.com/download.php
  - Just download the viewer, no need for the full package
- **RealVNC Viewer**: Professional, feature-rich
  - Download from: https://www.realvnc.com/en/connect/download/viewer/
- **UltraVNC Viewer**: Free, open-source
  - Download from: https://uvnc.com/downloads/ultravnc.html
- **Built-in Windows**: Remote Desktop Connection (limited VNC support)

**Connection Details:**
- **Server**: `192.168.0.230`
- **Port**: `5900` (or display `:0`)
- **No password required** (local network)

### Method 2: SSH into Dragon and use virsh console
```bash
# SSH into the dragon server directly
ssh dragon

# Note: Console access may not work with VNC-configured VMs
# If you get "cannot find character device <null>", use VNC instead
sudo virsh console kali-linux
# Use Ctrl+] to exit the console when done
```

**Note:** If you get the error `cannot find character device <null>`, this means the VM is configured for VNC graphics only (no serial console). Use VNC access instead.

### Method 3: Check VNC port and connect
```bash
# Check which VNC port the VM is using
ansible dragon -i inventory.ini -m command -a "virsh vncdisplay kali-linux" --become --ask-become-pass

# Then connect via VNC client using the displayed port
```

## Installing Kali Linux

Once connected via VNC:

1. **Boot from the installer** - The VM should boot from the Kali ISO
2. **Follow the Kali installer prompts**:
   - Select "Graphical install" or "Install" 
   - Choose language, location, keyboard
   - Configure network (should get DHCP automatically)
   - Set up users and passwords
   - Partition the disk (use the entire 20GB disk)
   - Install the system
3. **Complete installation and reboot**
4. **Remove the ISO after installation**:
   ```bash
   # Eject the installation media
   ansible dragon -i inventory.ini -m command -a "virsh change-media kali-linux hdc --eject" --become --ask-become-pass
   
   # Reboot to boot from installed system
   ansible dragon -i inventory.ini -m command -a "virsh reboot kali-linux" --become --ask-become-pass
   ```

**Important**: If you keep getting dropped into the installer after rebooting, you need to eject the ISO media first (step 4 above).

## Manual Setup Steps (Alternative)

1. **SSH into the server:**
   ```bash
   ssh dragon
   ```

2. **Download the Kali Linux ISO:**
   ```bash
   wget https://cdimage.kali.org/kali-2024.2/kali-linux-2024.2-installer-amd64.iso
   ```


3. **Create a VM disk image:**
   ```bash
   qemu-img create -f qcow2 ~/kali.qcow2 20G
   ```
   - 20GB is a reasonable minimum for Kali Linux. This leaves space for three additional Kubernetes nodes.

> **Note:** For your Kubernetes nodes, Flatcar Linux is a great choice for lightweight, secure VMs. Allocate 18GB per node if you plan to run three nodes alongside Kali on an 80GB disk.

**Example disk allocation for 80GB total:**
- Kali Linux VM: 20GB
- 3x Flatcar Kubernetes nodes: 18GB each (54GB)
- Remaining: 6GB for overhead

4. **Install the VM using virt-install:**
   ```bash
   virt-install \
     --name kali-linux \
     --ram 4096 \
     --vcpus 2 \
     --disk path=~/kali.qcow2,format=qcow2 \
     --cdrom ~/kali-linux-2024.2-installer-amd64.iso \
     --os-type linux \
     --os-variant debian11 \
     --network bridge=br0 \
     --graphics vnc,listen=0.0.0.0
   ```
   - Adjust RAM, CPU, disk size, and network bridge as needed.

5. **Access the VM installer:**
   - Use a VNC client to connect to the server’s IP on the VNC port (default 5900).
   - Complete the Kali installation in the VNC console.

6. **Start and manage the VM:**
   ```bash
   virsh list --all
   virsh start kali-linux
   virsh shutdown kali-linux
   ```

7. **SSH into Kali VM (after install):**
   - Find the VM’s IP address (`virsh domifaddr kali-linux` or check DHCP server).
   - SSH in: `ssh user@<kali-vm-ip>`


## Tips

- Use `virt-manager` (GUI) if you have X11 forwarding or local access.
- Automate with cloud-init for repeatable builds.
- You can expand storage for VMs or data by adding external USB drives to your server. These can be mounted and used for VM disk images or persistent storage.
