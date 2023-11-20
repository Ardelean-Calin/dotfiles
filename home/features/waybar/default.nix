{pkgs, ...}: let
  powermenu = pkgs.writeShellApplication {
    name = "powermenu.sh";
    runtimeInputs = with pkgs; [rofi pavucontrol];
    text = ''

      option1="  lock"
      option2="  logout"
      option3="󰂠  sleep"
      option4="  reboot"
      option5="  power off"

      options="$option1\n"
      options="$options$option2\n"
      options="$options$option3\n$option4\n$option5"

      choice=$(echo -e "$options" | rofi -dmenu -i -no-show-icons -l 5 -width 30 -p "Powermenu")

      case $choice in
      	"$option1")
      		# slock ;;
          echo "Lock";;
      	"$option2")
          echo "Logout";;
      		# qtile cmd-obj -o cmd -f shutdown ;;
      	"$option3")
      		systemctl suspend ;;
      	"$option4")
      		systemctl reboot ;;
      	"$option5")
      		systemctl poweroff ;;
      esac
    '';
  };
in {
  home.packages = [pkgs.waybar powermenu pkgs.pavucontrol];
  home.file.".config/waybar/config".source = ./config;
  home.file.".config/waybar/style.css".source = ./style.css;
  home.file.".config/waybar/modules.json".source = ./modules.json;
  #   programs.waybar = {
  #     enable = false; # Do not configure using Home Manager
  #     systemd.enable = true;
  #     package = pkgs.waybar.overrideAttrs (oldAttrs: {
  #       mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
  #     });

  #     # settings = {
  #     #   mainBar = {
  #     #     layer = "top";
  #     #     modules-left = ["custom/appmenu" "idle_inhibitor" "hyprland/submap"];
  #     #     modules-center = ["hyprland/workspaces"];
  #     #     modules-right = [
  #     #       "hyprland/language"
  #     #       "tray"
  #     #       "pulseaudio"
  #     #       "cpu"
  #     #       "memory"
  #     #       "disk"
  #     #       "clock"
  #     #       "custom/exit"
  #     #     ];

  #     #     # Modules
  #     #     "hyprland/workspaces" = {
  #     #       "on-click" = "activate";
  #     #       "active-only" = false;
  #     #       "all-outputs" = true;
  #     #       "format" = "{icon}";
  #     #       "format-icons" = {
  #     #         "urgent" = "";
  #     #         "active" = "";
  #     #         "default" = "";
  #     #         "sort-by-number" = true;
  #     #       };
  #     #     };
  #     #     "custom/appmenu" = {
  #     #       "format" = " ";
  #     #       "on-click" = "${pkgs.rofi}/bin/rofi -show drun -l 10 -show-icons";
  #     #     };
  #     #     "custom/exit" = {
  #     #       "format" = "";
  #     #       "on-click" = "${powermenu}/bin/powermenu.sh";
  #     #     };
  #     #     "hyprland/language" = {
  #     #       "format" = "{short}";
  #     #     };
  #     #     "hyprland/submap" = {
  #     #       format = "✌️  {}";
  #     #       max-length = 8;
  #     #     };
  #     #     "keyboard-state" = {
  #     #       "numlock" = true;
  #     #       "capslock" = true;
  #     #       "format" = "{name} {icon}";
  #     #       "format-icons" = {
  #     #         "locked" = "";
  #     #         "unlocked" = "";
  #     #       };
  #     #     };
  #     #     "idle_inhibitor" = {
  #     #       "format" = "{icon}";
  #     #       "format-icons" = {
  #     #         "activated" = "";
  #     #         "deactivated" = "";
  #     #       };
  #     #     };
  #     #     "tray" = {
  #     #       # "icon-size" = 21;
  #     #       "spacing" = 10;
  #     #     };
  #     #     "clock" = {
  #     #       # "timezone" = "America/New_York";
  #     #       "tooltip-format" = "<big>{ =%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
  #     #       "format-alt" = "{ =%Y-%m-%d}";
  #     #     };
  #     #     "cpu" = {
  #     #       "format" = "  {usage}%";
  #     #       "tooltip" = false;
  #     #     };
  #     #     "memory" = {
  #     #       "format" = "  {}%";
  #     #     };
  #     #     "disk" = {
  #     #       "format" = " {percentage_used}%";
  #     #     };
  #     #     "temperature" = {
  #     #       # "thermal-zone" = 2;
  #     #       # "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
  #     #       "critical-threshold" = 80;
  #     #       # "format-critical" = "{temperatureC}°C {icon}";
  #     #       "format" = "{temperatureC}°C {icon}";
  #     #       "format-icons" = ["" "" ""];
  #     #     };

  #     #     "network" = {
  #     #       # "interface" = "wlp2*"; # (Optional) To force the use of this interface
  #     #       "format-wifi" = "{essid} ({signalStrength}%) ";
  #     #       "format-ethernet" = "{ipaddr}/{cidr} ";
  #     #       "tooltip-format" = "{ifname} via {gwaddr} ";
  #     #       "format-linked" = "{ifname} (No IP) ";
  #     #       "format-disconnected" = "Disconnected ⚠";
  #     #       "format-alt" = "{ifname} = {ipaddr}/{cidr}";
  #     #     };
  #     #     "pulseaudio" = {
  #     #       # "scroll-step" = 1, # %, can be a float
  #     #       "format" = "{icon}  {volume}%";
  #     #       "format-bluetooth" = "{volume}% {icon} {format_source}";
  #     #       "format-bluetooth-muted" = " {icon} {format_source}";
  #     #       "format-muted" = " {format_source}";
  #     #       "format-source" = "{volume}% ";
  #     #       "format-source-muted" = "";
  #     #       "format-icons" = {
  #     #         "headphone" = "";
  #     #         "hands-free" = "";
  #     #         "headset" = "";
  #     #         "phone" = "";
  #     #         "portable" = "";
  #     #         "car" = "";
  #     #         "default" = ["" "" ""];
  #     #       };
  #     #       "on-click" = "pavucontrol";
  #     #     };
  #     #   };
  #     # };

  #     style = builtins.readFile ./style.css;
  #   };
  # }
}
