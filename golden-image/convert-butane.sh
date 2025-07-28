#!/bin/bash
# Convert Butane configuration to Ignition JSON for Flatcar Linux

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUTANE_FILE="$SCRIPT_DIR/kubernetes.bu"
IGNITION_FILE="$SCRIPT_DIR/kubernetes.ign"

# Check if butane is installed
if ! command -v butane &> /dev/null; then
    echo "Error: butane is not installed"
    echo ""
    echo "To install butane:"
    echo "  # On Ubuntu/Debian:"
    echo "  wget https://github.com/coreos/butane/releases/download/v0.19.0/butane-x86_64-unknown-linux-gnu -O /tmp/butane"
    echo "  sudo mv /tmp/butane /usr/local/bin/butane"
    echo "  sudo chmod +x /usr/local/bin/butane"
    echo ""
    echo "  # Or download from: https://github.com/coreos/butane/releases"
    exit 1
fi

echo "Converting Butane config to Ignition..."
echo "Input:  $BUTANE_FILE"
echo "Output: $IGNITION_FILE"

# Convert Butane to Ignition
butane --pretty --strict < "$BUTANE_FILE" > "$IGNITION_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Successfully converted Butane to Ignition"
    echo "📁 Generated: $IGNITION_FILE"
    echo ""
    echo "File size: $(wc -c < "$IGNITION_FILE") bytes"
    echo "JSON structure:"
    head -10 "$IGNITION_FILE"
    echo "..."
else
    echo "❌ Failed to convert Butane to Ignition"
    exit 1
fi
