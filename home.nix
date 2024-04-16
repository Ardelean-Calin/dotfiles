{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.xremap-flake.homeManagerModules.default
  ];

  dconf.settings = {
    # TODO: Feature-gate these behind a Gnome Config
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "nightthemeswitcher@romainvigier.fr"
        "appindicatorsupport@rgcjonas.gmail.com"
        "forge@jmmaranan.com"
      ];
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      center-new-windows = true;
      attach-modal-dialogs = true;
    };
    "org/gnome/desktop/interface" = {
      font-name = "Fira Sans Book 10";
      document-font-name = "Roboto Slab Regular 11";
      monospace-font-name = "Fira Mono Regular 11";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      focus-mode = "mouse";
      titlebar-font = "Fira Sans SemiBold 10";
    };
    "org/gnome/desktop/wm/keybindings" = {
      "minimize" = []; # Unbind Super+H from minimize
      "switch-to-workspace-1" = ["<Super>1"];
      "switch-to-workspace-2" = ["<Super>2"];
      "switch-to-workspace-3" = ["<Super>3"];
      "switch-to-workspace-4" = ["<Super>4"];
      "move-to-workspace-1" = ["<Shift><Super>1"];
      "move-to-workspace-2" = ["<Shift><Super>2"];
      "move-to-workspace-3" = ["<Shift><Super>3"];
      "move-to-workspace-4" = ["<Shift><Super>4"];
    };
    "org/gnome/shell/keybindings" = {
      "switch-to-application-1" = [];
      "switch-to-application-2" = [];
      "switch-to-application-3" = [];
      "switch-to-application-4" = [];
    };
  };

  fonts.fontconfig.enable = true;

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
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.keepassxc
    pkgs.podman
    pkgs.distrobox
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    pkgs.fira
    pkgs.fira-mono
    pkgs.roboto-slab

    # Gnome extension
    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.forge
    pkgs.gnomeExtensions.night-theme-switcher

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/calin/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  services = {
    syncthing.enable = true;
    # Setup Xremap
    xremap = {
      withGnome = true;
      yamlConfig = ''
        keymap:
          - name: main
            remap:
              Esc: Grave
              CapsLock: Esc
              Super-Shift-Key_Enter:
                launch: ["${pkgs.foot}/bin/foot"]
              Super-Shift-Key_F:
                launch: ["firefox"]
              Super-Shift-Key_Q: Alt-Key_F4
      '';
    };
  }; # Services END

  programs = {
    go = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Ardelean Calin";
      userEmail = "9417983+Ardelean-Calin@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
        rerere.enabled = true;
        diff.algorithm = "histogram";
        url."git@github.com:".insteadOf = "https://github.com/";
      };
    };
    foot = {
      enable = true;
      settings = {
        main = {
          shell = "${pkgs.zellij}/bin/zellij";
          font = "JetBrainsMonoNL Nerd Font:size=13";
          initial-window-size-chars = "140x30";
          term = "xterm-256color";
        };
        # Catppuccin Mocha
        colors = {
          foreground = "cdd6f4"; # Text
          background = "1e1e2e"; # Base
          regular0 = "45475a"; # Surface 1
          regular1 = "f38ba8"; # red
          regular2 = "a6e3a1"; # green
          regular3 = "f9e2af"; # yellow
          regular4 = "89b4fa"; # blue
          regular5 = "f5c2e7"; # pink
          regular6 = "94e2d5"; # teal
          regular7 = "bac2de"; # Subtext 1
          bright0 = "585b70"; # Surface 2
          bright1 = "f38ba8"; # red
          bright2 = "a6e3a1"; # green
          bright3 = "f9e2af"; # yellow
          bright4 = "89b4fa"; # blue
          bright5 = "f5c2e7"; # pink
          bright6 = "94e2d5"; # teal
          bright7 = "a6adc8"; # Subtext 0
        };
      };
    };
    zellij = {
      enable = true;
      settings = {
        default_shell = "fish";
        theme = "catppuccin-mocha";
      };
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
    helix = {
      enable = true;
      defaultEditor = true;
      extraPackages = [
        # Go
        pkgs.gopls
        pkgs.go
        pkgs.delve
        # Rust
        pkgs.cargo
        pkgs.rustc
        pkgs.rust-analyzer
        # Bash
        pkgs.nodePackages.bash-language-server
        pkgs.shellcheck
        # Nix
        pkgs.alejandra
        pkgs.nil
      ];
      # TODO Move inside a file and load it from disk
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          line-number = "relative";
          true-color = true;
          color-modes = true;
          bufferline = "always";
          cursorline = true;
          idle-timeout = 50;
          mouse = true;
          auto-format = true;
          soft-wrap = {
            enable = true;
          };
          cursor-shape = {
            insert = "block";
            normal = "block";
            select = "underline";
          };
          statusline = {
            left = ["mode" "spinner"];
            center = ["file-name"];
            right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
            separator = "│";
          };
          indent-guides = {
            render = true;
            character = "╎"; # Some characters that work well: ""▏"", ""┆"", ""┊"", ""⸽"";
            skip-levels = 1;
          };
          lsp = {
            display-inlay-hints = false;
            display-messages = true;
          };
          search.smart-case = true;
        };
        keys = {
          insert = {
            C-c = ["normal_mode" "toggle_comments" "insert_mode"];
          };
          normal = {
            "0" = "goto_line_start";
            G = "goto_line_end";
            X = "extend_line_above";
            ret = ["move_line_down" "goto_line_start"];
            # Move selections up and down
            C-j = ["ensure_selections_forward" "extend_to_line_bounds" "delete_selection" "paste_after"];
            C-k = ["ensure_selections_forward" "extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
          };
          select = {
            "0" = "goto_line_start";
            G = "goto_line_end";
            # Move selections up and down
            C-j = ["ensure_selections_forward" "extend_to_line_bounds" "delete_selection" "paste_after"];
            C-k = ["ensure_selections_forward" "extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
            v = ["expand_selection"];
            V = ["shrink_selection"];
          };
        };
      };
      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "alejandra";
              args = ["-"];
            };
          }
        ];
      };
    };
    starship = {
      enable = true;
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        ${pkgs.starship}/bin/starship init fish | source
      '';
      functions = {
        tmp = {
          description = "Create a temporary directory and navigate to it.";
          body = "cd (mktemp -d)";
        };
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
