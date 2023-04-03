{ pkgs, ... }:

{
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
    darwin.cf-private
    darwin.apple_sdk.frameworks.CoreServices
    # darwin.apple_sdk.frameworks.CoreFoundation
    # darwin.apple_sdk.frameworks.Security
    # darwin.apple_sdk.frameworks
    libiconv
    stdenv
    # zlib
  ];
  programs.nix-index.enable = true;

  # programs.nix-ld.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Dock and Mission Control
  system.defaults.dock = {
    autohide = true;
    expose-group-by-app = false;
    mru-spaces = false;
    # tilesize = 128;
    showhidden = true;
    # Disable all hot corners
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };

  # Login and lock screen
  system.defaults.loginwindow = {
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  # Use F1, F2, etc. keys as standard function keys.
  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}
