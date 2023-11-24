{pkgs, ...}: let
  win11-start = import ./win11-start.nix {inherit pkgs;};
  label-print = import ./label-print.nix {inherit pkgs;};
in {
  home.packages = [
    win11-start
    label-print
  ];
}
