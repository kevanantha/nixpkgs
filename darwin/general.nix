{ pkgs, ... }:

{
  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/services"
    "nrlquaker/createzap"
  ];

  homebrew.casks = [
    "1password"
    "1password-cli"
    "raycast"
    "google-chrome"
    "cleanshot"
    "topnotch"
    "figma"
    "spotify"
    "arc"
    "openvpn-connect"
    "notion"
    "zed"
    "readdle-spark"
    # "gpg-suite"
  ];
  # Networking
  /* networking.dns = [ */
  /*   "1.1.1.1" */
  /*   "8.8.8.8" */
  /* ]; */

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    #  kitty
     terminal-notifier
   ];
  programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  system.defaults.dock.autohide = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}
