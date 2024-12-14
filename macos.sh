#!/bin/bash
set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
    echo "Error: This script is only for macOS systems"
    exit 1
fi

echo "Starting system bootstrap..."

# Install Nix (this is the Determinate Systems installer which is more reliable)
if ! command -v nix &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Set up config directories
mkdir -p "$HOME/.config/nix"

# Clone config repo
cd "$HOME/.config" && rm -rf env
git clone https://github.com/idobbins/env.git env

# Symlink flake configuration
cp "$HOME/.config/env/nix/macos-flake.nix" "$HOME/.config/nix/flake.nix"

# Build and activate configuration
cd "$HOME/.config/nix"
nix profile install .

echo "Bootstrap complete! Please restart your terminal."
