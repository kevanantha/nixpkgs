{ config, lib, pkgs, ... }:

{
  # Nix configuration ------------------------------------------------------------------------------

  nix = {
    settings = {
      substituters = [
        "https://cache.komunix.org"
        "https://cache.nixos.org/"
        "https://kevanantha.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "kevanantha.cachix.org-1:fgi0EBYafgTX8c4ENp9ZP4tAf3HmDLUWOfB9jGDqBAo="
      ];

      trusted-users = [ "root" "kevan" "@admin" ];

      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];

      # Recommended when using `direnv` etc.
      keep-derivations = true;
      keep-outputs = true;
    };

    # enable garbage-collection on weekly and delete-older-than 30 day
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Shells -----------------------------------------------------------------------------------------

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    # bashInteractive
    /* fish */
    zsh
    # nushell
  ];

  # The option environment.variables.SHELL is no longer set automatically when,
  # eg. programs.zsh.enable is configured.
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
