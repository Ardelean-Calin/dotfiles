#!/usr/bin/env bash

# Step 1: Download prerequisites
# 1.1 Nix
if [ ! -d "/nix" ]; then 
 echo "Nix isn't installed on this system. Installing nix..."
 echo "Please enter your root password to create the /nix directory:"

 sh <(curl -L https://nixos.org/nix/install) --no-daemon --yes
 source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# 1.2 Create nix.conf if it doesn't exist
mkdir -p "$HOME/.config/nix"
touch "$HOME/.config/nix/nix.conf"

# 1.3 Enable Nix Flakes
if ! grep -qF "experimental-features = nix-command flakes" "$HOME/.config/nix/nix.conf"; then
  echo "Enabling nix flakes..."
  echo "experimental-features = nix-command flakes" | tee -a "$HOME/.config/nix/nix.conf"
fi

# Step 2:
# Install and init home-manager
if ! which home-manager 1> /dev/null; then
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

