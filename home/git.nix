{ config, pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      ignores = [
        ".DS_Store"
      ];
      delta = {
        enable = true;
      };
    };
  };
}
