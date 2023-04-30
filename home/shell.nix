{ config, pkgs, lib, ... }:

let
  inherit (config.home.user-info) nixConfigDirectory;
in
{
  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins = [ "wd" "git" ];

  programs.zsh.enable = true;
  programs.zsh.plugins = [
    {
      # will source zsh-autosuggestions.plugin.zsh
      name = "zsh-autosuggestions";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-autosuggestions";
        rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
        sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
      };
    }
    {
      # will source zsh-syntax-highlighting.plugin.zsh
      name = "zsh-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "754cefe0181a7acd42fdcb357a67d0217291ac47";
        sha256 = "kWgPe7QJljERzcv4bYbHteNJIxCehaTu4xU9r64gUM4=";
      };
    }
  ];
  programs.zsh.shellAliases = with pkgs; {
    # nb = "nix build ${nixConfigDirectory}#darwinConfigurations.\"${config.home.hostname}\".system";
    xnode = "nix develop ${nixConfigDirectory}/.\#node";
    drs = "darwin-rebuild switch --flake ${nixConfigDirectory}";
    nd = "nix develop";
    nb = "nix build";
    hm = "home-manager";
    pn = "pnpm";
    # ld = "lazydocker";
    tks = "tmux kill-session";
    zshconfig = "nvim ~/.zshrc";
    ohmyzsh = "nvim ~/.oh-my-zsh";
    vimrc = "nvim ~/.vimrc";
    vimconfig = "cd ~/.config/nvim && nvim ~/.config/nvim";
    v = "nvim";
    c = "clear";
    /* gacp='echo "What is the commit message mate?" && read MSG && git add . && git commit -m "$MSG" && ggp' */
    /* bitpr='echo "What branch?" && read MSG && open "https://bitbucket.org/mid-kelola-indonesia/talenta-core/pull-requests/new?source=$MSG&t=1" -a "Arc"' */
    pobsi = "wd obsi && git add . && git commit -m 'docs: update' && ggp";
    #  gac='echo "What is the commit message mate?" && read MSG && git add . && git commit -m "$MSG"'
    gac = "gaa && gc";
    gglm = "git pull origin master --rebase=false";
    gglmr = "git pull origin master --rebase";
    #  gwip='gaa && gc --no-verify'
    gaca = "gaa && gc --amend";
    /* gwip='echo "What is the commit message mate?" && read MSG && git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "$MSG [skip ci]"' */
    d = "docker";
    #  k='kubectl'
    dc = "docker compose";
    cat = "bat";
    #  find='fd'
    top = "btm";
    #  gd='git diff --color | delta | cat'
    #  gm='open "https://meet.google.com/landing?authuser=1" -a "Google Chrome"'
    /* gmeet='open "https://meet.google.com/landing?authuser=1" -a "Arc"' */
    /* sup='open "https://meet.google.com/tzr-broj-sjg?authuser=1&pli=1" -a "Arc"' */
    /* supl='echo "Gimme the link mate!" && read MSG && open $MSG -a "Arc"' */
    bsl = "brew services list";
    bs = "brew services";
    /* killport='echo "What port?" && read PORT && kill -9 $(lsof -ti tcp:$PORT) && echo "DONE BRO!"' */
    tx = "tmuxinator";
    # sl = "pmset sleepnow";
    ws = "webstorm";
  };
}
