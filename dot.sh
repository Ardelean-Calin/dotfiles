#!/usr/bin/env bash

# Step 1: Download prerequisites
# 1.1 Nix
if [ ! -d "/nix" ]; then 
 echo "Nix isn't installed on this system. Installing nix..."
 echo "Please enter your root password to create the /nix directory:"

 sudo mkdir -p /nix
 sh <(curl -L https://nixos.org/nix/install) --no-daemon --yes
 
fi

# 1.2 Create nix.conf if it doesn't exist
touch "$HOME/.config/nix/nix.conf"

# 1.3 Enable Nix Flakes
if ! grep -qF "experimental-features = nix-command flakes" "$HOME/.config/nix/nix.conf"; then
  echo "Enabling nix flakes..."
  echo "experimental-features = nix-command flakes" | tee -a "$HOME/.config/nix/nix.conf"
fi

# Step 2:
# Install and init home-manager
if ! which -s home-manager; then
  echo "Home manager not found. Installing..."
  nix run home-manager/release-23.11 -- init --switch
fi

# Clone the repository or update it
if [ ! -d "$HOME/.config/home-manager/.git" ]; then
  echo "Getting latest dotfiles..."
  rm -rf "$HOME/.config/home-manager"
  mkdir -p "$HOME/.config/home-manager"
  nix run nixpkgs#git -- clone https://github.com/Ardelean-Calin/dotfiles.git "$HOME/.config/home-manager"
else
  cd "$HOME/.config/home-manager" || exit
    nix run nixpkgs#git -- pull || exit
  cd - || exit
fi

echo "Done installing home-manager. Activating..."
home-manager switch --flake "$HOME/.config/home-manager/"

