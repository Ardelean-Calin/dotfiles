{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [rofi feh];
  home.file = {
    ".config/rofi/config.rasi".text = ''
      configuration {
        display-drun: "Applications";
        display-window: "Windows";
        drun-display-format: "{name}";
        font: "Fira Sans SemiBold 11";
        modi: "window,run,drun";
        hover-select: true;
        /* Disable MousePrimary as an entry selector */
        /* Without this setting you won't be able to set MousePrimary as an entry
           acceptor. */
        me-select-entry: "";

        /* Use either LMB single click or RMB single click or LMB double click
           to accept an entry */
        me-accept-entry: [ MousePrimary, MouseSecondary, MouseDPrimary ];
      }

      /* Dark theme. */
      @import "${config.xdg.cacheHome}/wal/colors-rofi-dark"

      window {
        width:700px;
      }

      element {
        padding:6;
      }

      element-text selected {
        text-color:@background;
      }

      prompt {
        text-color:#ffffff;
      }

      entry {
        text-color:#ffffff;
      }
    '';
  };
}
