{ pgks, ... }:

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
    "google-chrome-canary"
    "cleanshot"
    "topnotch"
    "figma"
    "spotify"
    "arc"
    "openvpn-connect"
    "notion"
    "zed"
    "readdle-spark"
    "mimestream"
    "obsidian"
    "clickup"
    # "cron"
    # "podman-desktop"
    "flipper"
    "warp"
    "espanso"
    "whatsapp"
    "displaylink"
    "steam"
    "orbstack" # Replacement for Docker Desktop
    "linear-linear"
    "anki"
  ];
}
