#!/bin/bash

# Script to automatically install ZeroTier and join a network on Ubuntu 22.04
# Network ID: 5cf115fb5def164e

# Exit on any error
set -e

echo "Starting ZeroTier installation and configuration..."

# Update package lists
echo "Updating package lists..."
apt-get update

# Install curl if not already installed
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    apt-get install -y curl
fi

# Install ZeroTier
echo "Installing ZeroTier..."
curl -s https://install.zerotier.com | sudo bash

# Wait for ZeroTier service to start
echo "Waiting for ZeroTier service to start..."
sleep 5

# Join the specified network
NETWORK_ID="5cf115fb5def164e"
echo "Joining ZeroTier network: $NETWORK_ID"
zerotier-cli join $NETWORK_ID

# Check status
echo "ZeroTier status:"
zerotier-cli status
echo "Network status:"
zerotier-cli listnetworks

echo "ZeroTier installation and network join completed!"
echo "Note: You may need to authorize this node in the ZeroTier Central dashboard."