{pkgs, ...}: {
  xdg.configFile."lf/icons".source = ./icons;
  programs.lf = {
    enable = true;
    settings = {
      preview = true;
      sixel = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    commands = {
      dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
      editor-open = ''$$EDITOR $f'';
      mkdir = ''
        ''${{
          printf "Directory Name: "
          read DIR
          mkdir -p $DIR
        }}
      '';
      set-wallpaper = ''
        ''${{
          change-wallpaper $f >/dev/null 2>&1
        }}
      '';
    };

    keybindings = {
      "<enter>" = "open";
      md = "mkdir";
      ee = "editor-open";
      V = ''''$${pkgs.bat}/bin/bat --paging=always "$f"'';
    };

    # Following this tutorial:
    # https://github.com/gokcehan/lf/wiki/Previews#with-kitty-and-pistol
    extraConfig = let
      # This is a script to preview video files taken from here: https://raw.githubusercontent.com/duganchen/kitty-pistol-previewer/main/vidthumb
      vidthumb = pkgs.writeShellApplication {
        name = "vidthumb";
        runtimeInputs = with pkgs; [ffmpegthumbnailer jq];
        text = ''
          if ! [ -f "$1" ]; then
          	exit 1
          fi

          cache="$HOME/.cache/vidthumb"
          index="$cache/index.json"
          movie="$(realpath "$1")"

          mkdir -p "$cache"

          if [ -f "$index" ]; then
          	thumbnail="$(jq -r ". \"$movie\"" <"$index")"
          	if [[ "$thumbnail" != "null" ]]; then
          		if [[ ! -f "$cache/$thumbnail" ]]; then
          			exit 1
          		fi
          		echo "$cache/$thumbnail"
          		exit 0
          	fi
          fi

          thumbnail="$(uuidgen).jpg"

          if ! ffmpegthumbnailer -i "$movie" -o "$cache/$thumbnail" -s 0 2>/dev/null; then
          	exit 1
          fi

          if [[ ! -f "$index" ]]; then
          	echo "{\"$movie\": \"$thumbnail\"}" >"$index"
          fi
          json="$(jq -r --arg "$movie" "$thumbnail" ". + {\"$movie\": \"$thumbnail\"}" <"$index")"
          echo "$json" >"$index"

          echo "$cache/$thumbnail"
        '';
      };
      previewer = pkgs.writeShellApplication {
        name = "previewer";
        runtimeInputs = with pkgs; [file pistol kitty chafa];
        text = ''
          # NOTE: Use this if your terminal has sixel support
          case "$(file -Lb --mime-type -- "$1")" in
              image/*)
                  chafa -f sixel -s "$2x$3" --animate false "$1"
                  exit 1
                  ;;
              *)
                  pistol "$1"
                  ;;
          esac
        '';
      };
    in ''
      set previewer ${previewer}/bin/previewer
    '';
  };
}
