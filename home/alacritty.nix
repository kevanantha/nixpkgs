{ pkgs, ... }:

{
  programs.alacritty.enable = true;
  programs.alacritty.package = pkgs.alacritty;
  programs.alacritty.settings = {
    env = {
      TERM = "xterm-256color";
    };
    window = {
      # opacity = 0.9;
      opacity = 1;
      dimension = {
        columns = 0;
        lines = 0;
      };
      position = {
        x = 0;
        y = 0;
      };
      padding = {
        x = 0;
        y = 0;
      };
      dynamic_title = true;
      dynamic_padding = true;
      startup_mode = "Maximized";
      title = "Alacritty";
      decorations = "full";
    };
    font = {
      normal = {
        family = "MonoLisa";
        style = "Book";
      };
      bold = {
        family = "MonoLisa";
        style = "Bold";
      };
      italic = {
        family = "MonoLisa";
        style = "Bold Italic";
      };
      size = 12.0;
      offset = {
        x = 0;
        y = 2;
      };
    };
    # font = {
    #   normal = {
    #     family = "JetBrainsMono Nerd Font";
    #     style = "Medium";
    #   };
    #   bold = {
    #     family = "JetBrainsMono Nerd Font";
    #     style = "Bold";
    #   };
    #   italic = {
    #     family = "JetBrainsMono Nerd Font";
    #     style = "Bold Italic";
    #   };
    #   size = 13.0;
    #   offset = {
    #     x = 0;
    #     y = 2;
    #   };
    # };
    colors = {
      primary = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
      };
      normal = {
        black = "#32344a";
        red = "#f7768e";
        green = "#9ece6a";
        yellow = "#e0af68";
        blue = "#7aa2f7";
        magenta = "#ad8ee6";
        cyan = "#449dab";
        white = "#787c99";
      };
      bright = {
        black = "#444b6a";
        red = "#ff7a93";
        green = "#b9f27c";
        yellow = "#ff9e64";
        blue = "#7da6ff";
        magenta = "#bb9af7";
        cyan = "#0db9d7";
        white = "#acb0d0";
      };
    };
    cursor = {
      style = "Block";
      blink = true;
      vi_mode_style = "Block";
      unfocused_hollow = false;
    };
  };
}
