#!/usr/bin/env bash

set -e  # Exit immediately if a command exits with a non-zero status

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function error {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

function success {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Ensure the script is run with root privileges
if [[ "$EUID" -ne 0 ]]; then
    error "Please run as root"
fi

# Build and switch NixOS system configuration
echo "Building and switching NixOS system configuration..."
if sudo nixos-rebuild switch --flake .#nixos; then
    success "NixOS system configuration updated!"
else
    error "Failed to update NixOS system configuration."
fi

# Build and switch Home Manager configuration
if command -v home-manager &> /dev/null; then
    echo "Building and switching Home Manager configuration..."
    if home-manager switch --flake .#claud@nixos; then
        success "Home Manager configuration updated!"
    else
        error "Failed to update Home Manager configuration."
    fi
else
    error "Home Manager not installed or available in PATH."
fi

# Clean up old generations and garbage collect
echo "Cleaning up old generations and running garbage collection..."

# Remove old system generations
echo "Pruning old system generations..."
sudo nix-collect-garbage --delete-older-than 30d

# Remove old home-manager generations (if necessary)
if home-manager generations &> /dev/null; then
    echo "Pruning old home-manager generations..."
    home-manager expire-generations '30d'
fi

# Garbage collection to free up unused space
echo "Running garbage collection..."
sudo nix-collect-garbage

success "System cleanup complete!"
