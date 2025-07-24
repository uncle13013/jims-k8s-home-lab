#!/bin/bash
# Wake-on-LAN script for Dell R610 Dragon server

MAC="14:fe:b5:d1:79:ef"
TARGET="192.168.0.255"

echo "Sending Wake-on-LAN magic packet to Dragon server..."
echo "MAC: $MAC"
echo "Target: $TARGET"

# Check if wakeonlan is installed
if command -v wakeonlan &> /dev/null; then
    wakeonlan $MAC
    echo "Magic packet sent using wakeonlan!"
else
    echo "wakeonlan not found. Install with: sudo apt install wakeonlan"
    echo "Or use the PowerShell method from the documentation."
fi

echo "Dragon server should boot up in 10-30 seconds..."
