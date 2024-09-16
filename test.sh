#!/usr/bin/env bash

set -e  # Exit immediately if a command exits with a non-zero status
sudo nixos-rebuild test --flake .#nixos --fast
home-manager switch --flake .#claud@nixos
