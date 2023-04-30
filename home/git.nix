{ config, pkgs, ... }:

let
  delta = "${pkgs.delta}/bin/delta";
  eFishery = {
    name = "kevan";
    email = "kevin.anantha@efishery.com";
    signingKey = "BD63AE6F8CD7FFB8";
  };
  kevan = {
    name = "kevin anantha (kevan)";
    email = "kevin.anantha@gmail.com";
    signingKey = "B0ECFB4FFE73033C";
  };
in
{
  programs = {
    git = {
      enable = true;
      userName = "${kevan.name}";
      userEmail = "${kevan.email}";
      signing.key = "${kevan.signingKey}";
      signing.gpgPath = "gpg";
      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
      ];
      extraConfig = {
        core.editor = "nvim";
        core.pager = delta;
        interactive.diffFilter = "${delta} --color-only";
        merge.conflictstyle = "diff3";
        diff.tool = "delta";
        diff.colorMoved = "default";
        gpg.program = "gpg";
        gpg.format = "openpgp";
        commit.gpgsign = true;
        # pull.ff = "only";
        pull.rebase = true;
        url = {
          "git@bitbucket.org:" = {
            insteadOf = "https://bitbucket.org/";
          };
          "git@gitlab.com:" = {
            insteadOf = "https://gitlab.com/";
          };
        };
      };
      includes = [
        {
          condition = "gitdir:~/w/";
          contents.user = eFishery;
        }
      ];
      delta = {
        enable = true;
        options = {
          naviagtion = true;
          light = false;
          side-by-side = true;
          line-numbers = true;
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-decoration-style = "bold yellow ul";
            file-style = "yellow ul";
          };
          features = "decorations";
          whitespace-error-style = "22 reverse";
        };
      };
    };
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
      settings.aliases = { };
    };
  };
}
