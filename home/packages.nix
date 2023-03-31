{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;

  home.activation = {
    copyApplications =
      lib.hm.dag.entryAfter [ "writeBoundary" ]
        (lib.optionalString (pkgs.stdenv.isDarwin)
          (
            let
              apps = pkgs.buildEnv {
                name = "home-manager-applications";
                paths = config.home.packages;
                pathsToLink = "/Applications";
              };
            in
            ''
              echo "setting up ${config.home.homeDirectory}/Applications/Home\ Manager\ Applications...">&2
              if [ ! -e ~/Applications -o -L ~/Applications ]; then
                ln -sfn ${apps}/Applications ~/Applications
              elif [ ! -e ~/Applications/Home\ Manager\ Apps -o -L ~/Applications/Home\ Manager\ Apps ]; then
                ln -sfn ${apps}/Applications ~/Applications/Home\ Manager\ Apps
              else
                echo "warning: ~/Applications and ~/Applications/Home Manager Apps are directories, skipping App linking..." >&2
              fi
            ''
          )
        )
    ;

    # this activation for update nix-index-database by system (darwin|linux)
    # nix-index-database it's use for "comma" - run without install
    updateNixIndexDB = lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.optionalString (config.programs.nix-index.enable) ''
      filename="index-x86_64-$(uname | tr A-Z a-z)"
      cacheNixIndex="$HOME/.cache/nix-index"
      if [ ! -d "$cacheNixIndex"]; then
        mkdir -p $cacheNixIndex
      fi
      cd $cacheNixIndex
      # -N will only download a new version if there is an update.
      ${pkgs.wget}/bin/wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
      ln -f $filename files
    ''
    );
  };

  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
    theme = "TwoDark";
  };

  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode;

  programs.alacritty.enable = true;
  programs.alacritty.package = pkgs.alacritty;
  programs.alacritty.settings = {
    env = {
      TERM = "xterm-256color";
    };
    window = {
      opacity = 0.9;
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
        family = "JetBrainsMono Nerd Font";
        style = "Medium";
      };
      bold = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold";
      };
      italic = {
        family = "JetBrainsMono Nerd Font";
        style = "Bold Italic";
      };
      size = 13.0;
      offset = {
        x = 0;
        y = 2;
      };
    };
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

  programs.exa = {
    enable = true;
    package = pkgs.exa;
    enableAliases = true;
    git = true;
    icons = true;
    extraOptions = [ "--long" "--header" "--classify" "--git" "--color=always" "--icons" ];
  };
  /* programs.exa.extraOptions = { */
  /*   icons = { */
  /*     enabled = true; */
  /*     all = true; */
  /*   }; */
  /*   grid = { */
  /*     enabled = true; */
  /*     header = true; */
  /*   }; */
  /*   color = "always"; */
  /*   git = "always"; */
  /* }; */

  /* programs.gpg = { */
  /*   enable = true; */
  /*   settings = { */
  /*     use-agent = true; */
  /*   }; */
  /* }; */

  # creating file with contents, that file will stored in nix-store
  # then symlink to homeDirectory.
  home.file.".gnupg/gpg-agent.conf".source = pkgs.writeTextFile {
    name = "home-gpg-agent.conf";
    text = lib.optionalString (pkgs.stdenv.isDarwin) ''
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '';
  };

  programs.bottom.enable = true;
  programs.bottom.package = pkgs.bottom;

  programs.gpg.enable = true;
  programs.gpg.package = pkgs.gnupg;
  /* programs.gpg.settings = { */
  /*   use-agent = true; */
  /* }; */

  programs.lazygit.enable = true;
  programs.lazygit.package = pkgs.lazygit;

  programs.jq.enable = true;
  programs.jq.package = pkgs.jq;

  home.packages = with pkgs; [
    neovim
    tmuxinator
    tmux
    tree
    slack
    openvpn
    httpie
    discord
    teams

    comma
    colima
    qemu
    home-manager
    /* spotify */
    postman

    # gnupg GUI
    gpa

    /* _1password-gui */
    /* _1password */
    dbeaver
    jetbrains.goland
    jetbrains.webstorm
    jetbrains.pycharm-professional

    /* google-chrome */
    zoom-us

    # nushell

    # oh-my-zsh
    fd
    ripgrep
  ];

  programs.zsh.oh-my-zsh.enable = true;
  # programs.zsh.oh-my-zsh.package = pkgs.oh-my-zsh;

  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        command_timeout = 1000;
        cmd_duration = {
          format = " [$duration]($style) ";
          style = "bold #EC7279";
          show_notifications = true;
        };
        nix_shell = {
          format = " [$symbol$state]($style) ";
        };
        battery = {
          full_symbol = "🔋 ";
          charging_symbol = "⚡️ ";
          discharging_symbol = "💀 ";
        };
        git_branch = {
          format = "[$symbol$branch]($style) ";
        };
        gcloud = {
          format = "[$symbol$active]($style) ";
        };
      };
    };
  };
}
