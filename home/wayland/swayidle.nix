{pkgs, ...}: {
  # services.swayidle = {
  #   enable = true;
  #   events = [
  #     {
  #       event = "before-sleep";
  #       command = "${pkgs.systemd}/bin/loginctl lock-session";
  #     }
  #     {
  #       event = "lock";
  #       command = "${pkgs.gtklock}/bin/gtklock";
  #     }
  #   ];
  #   systemdTarget = "hyprland-session.target";
  # };
  # systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
}
