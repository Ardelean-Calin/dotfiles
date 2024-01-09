{
  description = "Calin's NixOS Flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
  inputs.nixpkgs-master.url = "github:NixOS/nixpkgs/master";
  inputs.nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-23.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.hyprland.url = "github:hyprwm/Hyprland";
  # My Ollama Nix Flake
  inputs.ollama-cuda.url = "github:Ardelean-Calin/ollama-nix";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    nixpkgs-wayland,
    ollama-cuda,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    pkgs-master = import nixpkgs-master {
      inherit system;
      config = {
        cudaSupport = true;
        cudaCapabilities = ["8.6"];
        cudaEnableForwardCompat = false;
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      "calinpc" = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit system;
          inherit pkgs;
          inherit pkgs-master;
        };

        modules = [
          ollama-cuda.nixosModules.default
          ./nixos/configuration.nix
          ./hosts/calinpc
        ];
      };
    };
  };
}
