{
  description = "Calin's NixOS Flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
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
  in {
    nixosConfigurations = {
      "calinpc" = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
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
