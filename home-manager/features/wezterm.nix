{pkgs, ...}: {
  # programs.kitty = {
  #   enable = true;
  #   font = {
  #     name = "JetBrains Mono";
  #     size = 12;
  #     package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
  #   };
  #   settings = {
  #     window_padding_width = 3;
  #     disable_ligatures = "always";
  #   };
  #   extraConfig = ''
  #     shell fish
  #   '';
  #   shellIntegration.enableFishIntegration = true;
  # };

  # programs.wezterm = {
  #   enable = true;
  #   extraConfig = ''
  #     return {
  #       hide_tab_bar_if_only_one_tab = true,
  #       default_prog = {"${pkgs.fish}/bin/fish", "-l"},
  #       window_background_opacity = 0.95,
  #     }
  #   '';
  # };
}
