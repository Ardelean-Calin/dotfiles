{
  description = "Home Manager configuration of calin";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    zls-master = {
      url = "github:zigtools/zls/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-master.url = "github:helix-editor/helix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    zls-master,
    # helix-master,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = [
      inputs.neovim-nightly-overlay.overlay

      (final: prev: {
        zls = zls-master.packages.${system}.default;
      })

      # (final: prev: {
      #   helix = helix-master.packages.${system}.default;
      # })
    ];
    pkgs = import nixpkgs {
      inherit system;
      inherit overlays;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations."calin" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs;
      };

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
