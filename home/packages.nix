{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;
  programs.neovim.defaultEditor = true;

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
  # programs.bat.config = {
  #   style = "plain";
  #   theme = "Dracula";
  # };

  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.go.enable = true;
  programs.go.package = pkgs.go;

  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode;

  programs.exa = {
    enable = true;
    package = pkgs.exa;
    enableAliases = true;
    git = true;
    icons = true;
    extraOptions = [ "--long" "--header" "--classify" "--git" "--color=always" "--icons" ];
  };

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

  programs.lazygit.enable = true;
  programs.lazygit.package = pkgs.lazygit;

  programs.jq.enable = true;
  programs.jq.package = pkgs.jq;

  home.packages = with pkgs; [
    coreutils
    wget

    neovim
    tmuxinator
    tmux
    tree
    slack
    openvpn
    httpie
    discord
    teams

    deno
    # go
    gopls
    # gotools
    go-tools

    comma
    colima
    docker
    # podman
    qemu
    home-manager
    postman
    neofetch

    # gnupg GUI
    gpa
    gcc

    dbeaver
    jetbrains.goland
    jetbrains.webstorm
    jetbrains.pycharm-professional

    zoom-us

    # nushell
    cachix

    # wezterm
    fd
    ripgrep
  ] ++ lib.optionals
    stdenv.isDarwin
    [
      mas
      # xbar
      cocoapods
      m-cli # useful macOS CLI commands
      xcode-install
      # telegram
      # iriun-webcam
      # clipy
      # googlechrome
    ];
}
