{
  description = "Calin's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
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

        modules = [
          ./nixos/configuration.nix
        ];
      };
    };
  };
}
