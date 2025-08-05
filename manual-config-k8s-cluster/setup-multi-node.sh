#!/bin/bash

echo "Setting up multi-node Kind cluster..."

# Delete existing cluster if it exists
kind delete cluster --name kind 2>/dev/null || true

# Create new multi-node cluster
kind create cluster --name kind --config kind-multi-node.yaml

echo ""
echo "Multi-node cluster created!"
echo ""

# Show cluster info
kubectl cluster-info
echo ""

# Show nodes
kubectl get nodes
echo ""

# Show node details
echo "Node details:"
kubectl describe nodes 