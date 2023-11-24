{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./virtualisation
  ];

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
