#!/bin/bash
# Test script to validate Ignition configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUTANE_FILE="$SCRIPT_DIR/kubernetes.bu"
IGNITION_FILE="$SCRIPT_DIR/kubernetes.ign"

echo "=== Ignition Configuration Validation ==="

# Test 1: Validate Butane syntax
echo "🔍 Testing Butane syntax..."
if butane --strict < "$BUTANE_FILE" > /dev/null; then
    echo "✅ Butane configuration is valid"
else
    echo "❌ Butane configuration has syntax errors"
    exit 1
fi

# Test 2: Check if Ignition file exists and is recent
echo "🔍 Checking Ignition file..."
if [ -f "$IGNITION_FILE" ]; then
    # Check if .ign is newer than .bu (or same age)
    if [ "$IGNITION_FILE" -nt "$BUTANE_FILE" ] || [ "$IGNITION_FILE" -ef "$BUTANE_FILE" ]; then
        echo "✅ Ignition file exists and is up-to-date"
    else
        echo "⚠️  Ignition file is older than Butane config"
        echo "   Run: ./convert-butane.sh"
    fi
else
    echo "❌ Ignition file not found"
    echo "   Run: ./convert-butane.sh"
    exit 1
fi

# Test 3: Validate Ignition JSON structure
echo "🔍 Validating Ignition JSON structure..."
if jq empty < "$IGNITION_FILE" 2>/dev/null; then
    echo "✅ Ignition JSON is valid"
else
    echo "❌ Ignition JSON is malformed"
    exit 1
fi

# Test 4: Check for required components
echo "🔍 Checking required components..."

# Check for Docker configuration
if jq -e '.storage.files[] | select(.path == "/etc/docker/daemon.json")' "$IGNITION_FILE" > /dev/null; then
    echo "✅ Docker daemon configuration present"
else
    echo "❌ Docker daemon configuration missing"
    exit 1
fi

# Check for Kubernetes download service
if jq -e '.systemd.units[] | select(.name == "download-k8s.service")' "$IGNITION_FILE" > /dev/null; then
    echo "✅ Kubernetes download service present"
else
    echo "❌ Kubernetes download service missing"
    exit 1
fi

# Check for kubelet service
if jq -e '.systemd.units[] | select(.name == "kubelet.service")' "$IGNITION_FILE" > /dev/null; then
    echo "✅ Kubelet service configuration present"
else
    echo "❌ Kubelet service configuration missing"
    exit 1
fi

# Check for required directories
required_dirs=("/etc/kubernetes" "/var/lib/kubelet" "/opt/bin" "/opt/cni/bin")
for dir in "${required_dirs[@]}"; do
    if jq -e ".storage.directories[] | select(.path == \"$dir\")" "$IGNITION_FILE" > /dev/null; then
        echo "✅ Directory $dir configured"
    else
        echo "❌ Directory $dir missing"
        exit 1
    fi
done

# Test 5: File size check (reasonable size)
file_size=$(wc -c < "$IGNITION_FILE")
if [ "$file_size" -gt 1000 ] && [ "$file_size" -lt 20000 ]; then
    echo "✅ Ignition file size reasonable: ${file_size} bytes"
else
    echo "⚠️  Ignition file size unusual: ${file_size} bytes"
fi

echo ""
echo "🎉 All validation tests passed!"
echo "📁 Configuration ready for deployment"
echo ""
echo "Next steps:"
echo "1. Deploy with Vagrant: cd ../vagrant-cluster/toshiba-satellite && vagrant up"
echo "2. SSH to node: vagrant ssh master-1"
echo "3. Check setup: sudo journalctl -u download-k8s.service"
