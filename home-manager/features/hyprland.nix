{pkgs, ...}: {
  imports = [
    ./waybar
  ];

  home.sessionVariables = {
    SDL_VIDEODRIVEVER = "wayland";
  };

  # Extract color schemes from wallpaper
  programs.pywal.enable = true;

  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    font = "Fira Sans Book 10";
    borderRadius = 10;
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.xwayland.enable = true;
  # wayland.windowManager.hyprland.enableNvidiaPatches = true;
  wayland.windowManager.hyprland.extraConfig = ''
    # env = LIBVA_DRIVER_NAME,nvidia
    env = XDG_SESSION_TYPE,wayland
    # env = GBM_BACKEND,nvidia-drm
    # env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    # env = WLR_NO_HARDWARE_CURSORS,1
    # env = WLR_DRM_DEVICES,/dev/dri/card1
    monitor=,highrr,auto,auto

    exec-once = swww init
    exec-once = waybar &
    # USB Auto-mount
    exec-once = udiskie &
    # exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
    # exec-once = ${pkgs.blueman}/bin/blueman-applet &
    # exec-once = ${pkgs.swaybg}/bin/swaybg -i ~/.wallpapers/current-wallpaper -m fill &

    $mod = SUPER

    bindr = $mod, SPACE, exec, pkill rofi || rofi -show drun -show-icons
    bind = $mod SHIFT, F, exec, firefox
    bind = $mod, Return, exec, wezterm
    bind = , Print, exec, grimblast copy area

    # Take a screenshot and copy to clipboard
    bind = $mod SHIFT, S, exec, ${pkgs.writeShellScriptBin "screenshot.sh" ''
      ${pkgs.grim}/bin/grim -l 0 -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png
    ''}/bin/screenshot.sh

    bind = $mod, Q, killactive,
    bind = $mod SHIFT, M, exit,
    bind = $mod, V, togglefloating,
    bind = $mod, F, fullscreen, 0 # Fullscreeen
    bind = $mod, M, fullscreen, 1 # Maximize
    bind = $mod, P, pseudo, # dwindle
    bind = $mod, J, togglesplit, # dwindle
    bind = $mod, h, movefocus, l
    bind = $mod, l, movefocus, r
    bind = $mod, k, movefocus, u
    bind = $mod, j, movefocus, d

    bind=$mod SHIFT, W, exec, change-wallpaper

    # will switch to a submap called resize
    bind=ALT,R,submap,resize

    # will start a submap called "resize"
    submap=resize

    # sets repeatable binds for resizing the active window
    binde=,l,resizeactive,10 0
    binde=,h,resizeactive,-10 0
    binde=,k,resizeactive,0 -10
    binde=,j,resizeactive,0 10
    bind=$mod,h,swapwindow,l
    bind=$mod,j,swapwindow,d
    bind=$mod,k,swapwindow,u
    bind=$mod,l,swapwindow,r

    # use reset to go back to the global submap
    bind=,escape,submap,reset
    bind=ALT,R,submap,reset

    # will reset the submap, meaning end the current one and return to the global one
    submap=reset

    # Move/resize windows with mod + LMB/RMB and dragging
    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow
    # Move selected window to workspace
    bind = $mod,Tab,cyclenext,
    bind = $mod SHIFT, L, movetoworkspace, +1
    bind = $mod SHIFT, H, movetoworkspace, -1
    bind = $mod SHIFT, E, movetoworkspace, empty
    bind = $mod, E, workspace, empty
    bind = $mod CTRL, L, workspace, +1
    bind = $mod CTRL, H, workspace, -1

    windowrulev2=size 1280 720,title:(Calendar)
    windowrulev2=float,title:(Calendar)
    windowrulev2=center,title:(Calendar)

    windowrulev2 = float, title:^(Picture-in-Picture)$
    windowrulev2 = float,class:(wezterm)title:^(nmtui)$
    # Looking Glass Client for Windows VM
    windowrulev2 = noinitialfocus,title:^(win11.*)$
    windowrulev2 = maximize,title:^(win11.*)$
    windowrulev2 = forceinput,title:^(win11.*)$
    windowrulev2 = workspace empty,title:^(win11.*)$

    # workspaces
    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $mod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
        ''
      )
      10)}

    # ---------------------------------------------------------------------
    # Load pywal color file
    # ---------------------------------------------------------------------
    source = ~/.cache/wal/colors-hyprland.conf

    general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5
        gaps_out = 10
        border_size = 3
        col.active_border = rgba(ffffffee)
        col.inactive_border = $color11

        layout = dwindle
    }

    decoration {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10

        drop_shadow = yes
        shadow_range = 30
        shadow_render_power = 3
        col.shadow = 0x66000000

        active_opacity = 1.0
        inactive_opacity = 0.9
        fullscreen_opacity = 1.0

        blur {
          enabled = true
          size = 3
          passes = 1
          new_optimizations = on
          blurls = waybar
        }

        # blur = yes
        # blur_size = 3
        # blur_passes = 1

        # drop_shadow = yes
        # shadow_range = 4
        # shadow_render_power = 3
        # col.shadow = rgba(1a1a1aee)
    }

    input {
        kb_layout = us,ro
        kb_options = grp:alt_shift_toggle
    }
  '';
}
