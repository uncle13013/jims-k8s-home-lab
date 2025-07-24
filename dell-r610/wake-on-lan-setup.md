# Wake-on-LAN Setup for Dell R610

This guide sets up Wake-on-LAN (WOL) to remotely power on the Dell R610 server, helping save electricity when the server isn't needed.

## Server Information

- **MAC Address**: `14:fe:b5:d1:79:ef` (eno1 interface)
- **IP Address**: `192.168.0.230`
- **Interface**: `eno1`

## Automated Setup with Ansible

The WOL setup has been automated. Run this playbook to configure WOL:

```bash
ansible-playbook -i inventory.ini setup-wake-on-lan.yml --ask-become-pass
```

## Manual Setup Steps

### 1. Check WOL Support
```bash
# Check if the network interface supports WOL
sudo ethtool eno1 | grep Wake-on
```

### 2. Enable WOL
```bash
# Enable Wake-on-LAN (temporary - until reboot)
sudo ethtool -s eno1 wol g
```

### 3. Make WOL Persistent
Create a systemd service to enable WOL on boot:

```bash
# Create systemd service file
sudo tee /etc/systemd/system/wake-on-lan.service << 'EOF'
[Unit]
Description=Enable Wake-on-LAN
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -s eno1 wol g
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl enable wake-on-lan.service
sudo systemctl start wake-on-lan.service
```

## Sending Magic Packets

### From Linux/macOS
```bash
# Install wakeonlan if not present
sudo apt install wakeonlan  # Ubuntu/Debian
# or
brew install wakeonlan       # macOS

# Send magic packet
wakeonlan 14:fe:b5:d1:79:ef
```

### From Windows
```powershell
# Using PowerShell (built-in method)
$mac = "14:fe:b5:d1:79:ef"
$target = "192.168.0.255"  # broadcast address
$macBytes = $mac -split ":" | ForEach-Object { [byte]("0x" + $_) }
$packet = [byte[]](@(255) * 6) + ($macBytes * 16)
$udpClient = New-Object System.Net.Sockets.UdpClient
$udpClient.Send($packet, $packet.Length, $target, 9)
$udpClient.Close()
```

Or download a WOL utility like:
- **WOL Magic Packet Sender** (free Windows app)
- **Wake-On-LAN Sender** (Windows Store)

### From Mobile Apps
- **Wake On Lan** (Android)
- **Mocha WOL** (iOS)

## Testing WOL

1. **Power down the server**:
   ```bash
   sudo shutdown -h now
   ```

2. **Wait for complete shutdown** (about 30 seconds)

3. **Send magic packet** from another device:
   ```bash
   wakeonlan 14:fe:b5:d1:79:ef
   ```

4. **Server should boot up** within 10-30 seconds

## Troubleshooting

### WOL Not Working
- **Check BIOS settings**: Ensure Wake-on-LAN is enabled in BIOS
- **Check power settings**: Some systems disable WOL in power management
- **Verify network**: WOL works on local network, not over internet (unless router configured)
- **Check cable**: WOL requires wired connection, not WiFi

### BIOS Settings to Check
- **Power Management**: Enable "Wake on LAN"
- **Network Boot**: May need to be enabled
- **Deep Sleep**: Disable if WOL doesn't work

### Verify WOL Status
```bash
# Check current WOL status
sudo ethtool eno1 | grep -i wake
```

## Power Scheduling

You can combine WOL with scheduled shutdown for automatic power management:

```bash
# Example: Schedule daily shutdown at 11 PM
sudo crontab -e
# Add: 0 23 * * * /sbin/shutdown -h now
```

Then use WOL to wake it up when needed!

## Security Considerations

- **Local network only**: WOL works on local network by default
- **No authentication**: Magic packets don't require authentication
- **Firewall**: Consider firewall rules if exposing WOL over internet
- **VPN**: Use VPN for secure remote WOL access

## Next Steps

- Set up scheduled shutdown for automatic power saving
- Create scripts or shortcuts for easy WOL access
- Configure router for WOL over internet (if needed)
- Consider UPS for graceful shutdown on power loss
