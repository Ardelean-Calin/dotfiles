{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # ./virtualisation
  ];

  config.nixpkgs.config.cudaSupport = true;
  config.services.ollama = {
    enable = true;
  };
}
