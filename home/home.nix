{
  pkgs,
  inputs,
  config,
  ...
}: let
  win11-start = import ./win11-start.nix {inherit pkgs;};
  change-wallpaper = pkgs.writeShellApplication {
    name = "change-wallpaper";
    runtimeInputs = with pkgs; [pywal swww waybar libnotify];
    text = ''
      set +o nounset
      if [ -z "$1" ]; then
        # Random wallpaper
        wal -q -i ~/.wallpapers/
      else
        wal -q -i "$1"
      fi
      # shellcheck source=/dev/null
      source "$HOME/.cache/wal/colors.sh" 2>/dev/null
      # NOTE: Not needed due to home-manager pywal module
      # cp ~/.cache/wal/colors-kitty.conf ~/.config/kitty/current-theme.conf
      # shellcheck disable=SC2154
      cp "$wallpaper" ~/.cache/current_wallpaper.jpg

      # -----------------------------------------------------
      # get wallpaper iamge name
      # -----------------------------------------------------
      # shellcheck disable=SC2001
      newwall=$(echo "$wallpaper" | sed "s|$HOME/.wallpapers/||g")
      # -----------------------------------------------------
      # Set the new wallpaper
      # -----------------------------------------------------
      swww img "$wallpaper" --transition-type center --transition-fps 100 --transition-duration 1.0

      # Relaunch waybar
      pkill waybar 2>/dev/null
      nohup waybar &

      # -----------------------------------------------------
      # Send notification
      # -----------------------------------------------------
      notify-send "Theme and Wallpaper updated" "With image $newwall"

      echo "DONE!"
    '';
  };
in {
  imports = [
    inputs.xremap-flake.homeManagerModules.default
    inputs.nix-colors.homeManagerModules.default
    ./features/hyprland.nix
    ./features/rofi.nix
    ./features/special.nix
    ./features/lf.nix
    ./wayland
  ];

  # Set base16 colorscheme for all supported applications
  colorScheme = inputs.nix-colors.colorSchemes.everforest;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "calin";
  home.homeDirectory = "/home/calin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk.font = {
    name = "Fira Sans Book";
    package = pkgs.fira;
    size = 10;
  };

  fonts.fontconfig.enable = true;

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batman batdiff];
  };

  programs.go = {
    enable = true;
  };

  programs.pistol = {
    enable = true;
    associations = [
      {
        mime = "text/*";
        command = "${pkgs.bat}/bin/bat --paging=never --color=always %pistol-filename%";
      }
    ];
  };

  programs.git = {
    enable = true;
    userName = "Ardelean Calin";
    userEmail = "9417983+Ardelean-Calin@users.noreply.github.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = true;
    enableAliases = true;
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
    ];
    functions = {
      config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv";
      man = "batman $argv";
      take = {
        description = "Create a directory tree and cd into it.";
        body = "mkdir -p \"$argv[1]\" && cd \"$argv[1]\"";
      };
      r = {
        description = "Navigate to the root of the current git repository.";
        body = "cd \"$(git rev-parse --show-toplevel 2>/dev/null)\"";
      };
      tmp = {
        description = "Create a temporary directory and navigate to it.";
        body = "cd $(mktemp -d)";
      };
      lfcd = {
        description = "Navigate to a given directory using the lf file manager.";
        body = ''
          set -l dir $(${pkgs.lf}/bin/lf -print-last-dir "$argv")
          while ! cd "$dir" 2> /dev/null
              set -l dir $(dirname "$dir")
          end
        '';
      };
    };
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
    };
  };

  # programs.tmux = {
  #   enable = true;
  # };

  # programs.zellij = {
  #   enable = true;
  #   enableFishIntegration = true;
  #   settings = {
  #     default_shell = "fish";
  #     theme = "gruvbox_dark";
  #     default_layout = "compact";
  #     pane_frames = false;
  #     ui = {
  #       pane_frames = {
  #         rounded_corners = false;
  #         hide_session_name = true;
  #       };
  #     };
  #     layout = {
  #     };
  #   };
  # };

  programs.firefox = {
    enable = true;

    profiles.calin = {
      settings = {
        "signon.rememberSignons" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.download.panel.shown" = true;
        "datareporting.healthreport.uploadEnabled" = false;
      };

      search.engines = {
        #   "Brave" = {
        #     urls = [
        #       {
        #         template = "https://search.brave.com/search";
        #         params = [
        #           {
        #             name = "q";
        #             value = "{searchTerms}";
        #           }
        #         ];
        #       }
        #     ];
        #     iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/favicon-32x32.86083f5b.png";
        #     updateInterval = 24 * 60 * 60 * 1000; # every day
        #     definedAliases = ["@bv"];
        #   };

        "Kagi" = {
          urls = [
            {
              template = "https://kagi.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };

        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };

        "Home-Manager Options" = {
          urls = [{template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";}];
          iconUpdateURL = "https://mipmip.github.io/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = ["@hm"];
        };
      };

      search.default = "Kagi";
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        sponsorblock
        darkreader
        return-youtube-dislikes
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "blur-my-shell@aunetx"
      ];
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      center-new-windows = true;
      attach-modal-dialogs = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  services.xremap = {
    yamlConfig = ''
      keymap:
        - name: main
          remap:
            Esc: Grave
            CapsLock: Esc
    '';
  };
  # USB automount
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };

  xdg.desktopEntries = {
    win11 = {
      name = "Windows 11";
      genericName = "Virtual Machine";
      exec = "win11-start";
      terminal = false;
      categories = ["Application"];
      icon = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/128x128/apps/distributor-logo-windows.svg";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    # cursorTheme = {
    #	  name = "Numix-Cursor";
    #  	package = pkgs.numix-cursor-theme;
    # };
  };

  programs.helix.defaultEditor = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    change-wallpaper
    pkgs.libnotify
    pkgs.transmission
    pkgs.steam
    pkgs.swww
    pkgs.wget
    pkgs.unzip
    pkgs.polkit-kde-agent
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    # pkgs.go
    pkgs.wezterm
    pkgs.zig
    pkgs.fzy
    pkgs.fzf
    pkgs.wl-clipboard
    pkgs.gcc-arm-embedded
    pkgs.lazygit
    pkgs.xfce.thunar

    pkgs.alejandra # Nix code formatter
    pkgs.stylua

    # Other development tools
    pkgs.openocd

    # GNOME extensions
    pkgs.gnomeExtensions.blur-my-shell

    # Language servers
    pkgs.lua-language-server
    pkgs.gopls
    pkgs.delve
    pkgs.rust-analyzer
    pkgs.nodePackages.bash-language-server
    pkgs.taplo
    pkgs.nil
    pkgs.zls # Loaded from overlay. Master version
    pkgs.clang
    pkgs.marksman
    pkgs.gnome.geary

    pkgs.kicad-small
    # pkgs.neovim-nightly # Nightly version of Neovim until 0.10.0 release
    pkgs.helix
    pkgs.prusa-slicer
    pkgs.pulseview

    pkgs.keepassxc

    # My custom shell scripts
    win11-start

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    pkgs.iosevka

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Copy the wallpapers via symlink
  home.file.".wallpapers" = {
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wallpapers";
  };

  # This way we can easily modify the dotfiles in `dots` and have immediate effect.
  xdg.configFile."wezterm" = {
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dots/wezterm";
  };
  xdg.configFile."helix" = {
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dots/helix";
  };
  xdg.configFile."wal" = {
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dots/wal";
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/calin/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
