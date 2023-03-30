{
  description = "kevan darwin configuration";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.utils.follows = "flake-utils";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Flake utilities
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    malob.url = "github:malob/nixpkgs";
  };

  outputs = { self, nixpkgs-unstable, darwin, home-manager, malob, flake-utils, ... }@inputs:
    let
      inherit (nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      flakeContext = {
        inherit inputs;
      };

      homeStateVersion = "23.05";

      nixpkgsDefault = {
        config = {
          allowUnfree = true;
          /* allowBroken = true; */
          /* allowAliases = true; */
        };
        overlays = attrValues self.overlays;
      };

      primaryUserDefault = rec {
        username = "kevan";
        fullName = "kevan";
        email = "kevin.anantha@gmail.com";
        nixConfigDirectory = "/Users/${username}/.config/nixpkgs";
      };
    in
    {
      # nix fmt
      formatter.x86_64-darwin = nixpkgs-unstable.legacyPackages.x86_64-darwin.nixpkgs-fmt;

      # Add some additional functions to `lib`.
      /* lib = inputs.nixpkgs-unstable.lib.extend (_: _: { */
      /*   mkDarwinSystem = malob.lib.mkDarwinSystem inputs; */
      /* }); */

      # Overlays --------------------------------------------------------------------------------{{{
      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefault) config;
          };
        };
        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefault) config;
          };
        };
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefault) config;
          };
        };
        apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsDefault) config;
          };
        };

        # Overlay that adds various additional utility functions to `vimUtils`
        /* vimUtils = import ./overlays/vimUtils.nix; */

        # Overlay that adds some additional Neovim plugins
        /* vimPlugins = final: prev: */
        /*   let */
        /*     inherit (self.overlays.vimUtils final prev) vimUtils; */
        /*   in */
        /*   { */
        /*     vimPlugins = prev.vimPlugins.extend (_: _: */
        /*       # Useful for testing/using Vim plugins that aren't in `nixpkgs`. */
        /*       vimUtils.buildVimPluginsFromFlakeInputs inputs [ */
        /*         # Add flake input names here for a Vim plugin repos */
        /*       ] // { */
        /*         # Other Vim plugins */
        /*         inherit (inputs.cornelis.packages.${prev.stdenv.system}) cornelis-vim; */
        /*       } */
        /*     ); */
        /*   }; */
      };
      # }}}

      # Modules
      darwinModules = {
        /* home-manager = home-manager.darwinModules.home-manager; */

        kevan-bootstrap = import ./darwin/bootstrap.nix;
        /* kevan-default = ./darwin/default.nix; */
        kevan-general = import ./darwin/general.nix;

        users-primaryUser = import ./modules/user.nix;
        /* kevan-homebrew = ./darwin/homebrew.nix; */
      };

      homeManagerModules = {
        # My configurations
        kevan-git = import ./home/git.nix;
        kevan-packages = import ./home/packages.nix;
        kevan-shell = import ./home/shell.nix;
        /* kevan-colors = import ./home/colors.nix; */
        /* kevan-config-files = import ./home/config-files.nix; */
        /* kevan-fish = import ./home/fish.nix; */
        /* kevan-git-aliases = import ./home/git-aliases.nix; */
        /* kevan-gh-aliases = import ./home/gh-aliases.nix; */
        /* kevan-kitty = import ./home/kitty.nix; */
        /* kevan-neovim = import ./home/neovim.nix; */
        /* kevan-starship = import ./home/starship.nix; */
        /* kevan-starship-symbols = import ./home/starship-symbols.nix; */

        # Modules I've created
        /* colors = import ./modules/home/colors; */
        /* programs-neovim-extras = import ./modules/home/programs/neovim/extras.nix; */
        /* programs-kitty-extras = import ./modules/home/programs/kitty/extras.nix; */

        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
      };

      # System configurations
      darwinConfigurations = rec {
        # Minimal macOS configurations to bootstrap systems
        bootstrap-x86 = makeOverridable darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsDefault; } ];
        };

        bootstrap-arm = self.darwinConfigurations.bootstrap-x86.override {
          system = "aarch64-darwin";
        };

        /* Wismas-MacBook-Pro = makeOverridable darwin.lib.darwinSystem { */
        # Wismas-MacBook-Pro = makeOverridable self.lib.mkDarwinSystem (primaryUserDefault // {
        Wismas-MacBook-Pro = makeOverridable malob.lib.mkDarwinSystem (primaryUserDefault // {
          system = "x86_64-darwin";
          modules = attrValues self.darwinModules ++ singleton {
            nixpkgs = nixpkgsDefault;
            networking.computerName = "Wisma’s 💻";
            networking.hostName = "Wismas-MacBook-Pro";
            networking.knownNetworkServices = [
              "Wi-Fi"
              "USB 10/100/1000 LAN"
            ];
            nix.registry.my.flake = inputs.self;
          };
          inherit homeStateVersion;
          homeModules = attrValues self.homeManagerModules;
        });

        /* Wismas-MacBook-Pro = bootstrap-x86.override { */
        /*   #system = "x86_64-darwin"; */
        /*   modules = attrValues self.darwinModules ++ [ */
        /*     { users.primaryUser = primaryUserDefault; } */
        /*   ] ++ [ */
        /*     home-manager.darwinModules.home-manager */
        /*     ( */
        /*       { config, pkgs, ... }: */
        /*       let */
        /*         inherit (config.users) primaryUser; */
        /*       in */
        /*       { */
        /*         nixpkgs = nixpkgsDefault; */
        /**/
        /*         # Hack to support legacy worklows that use `<nixpkgs>` etc. */
        /*         nix.nixPath = { nixpkgs = "${inputs.nixpkgs-unstable}"; }; */
        /**/
        /*         # `home-manager` config */
        /*         users.users.${primaryUser.username} = { */
        /*           home = "/Users/${primaryUser.username}"; */
        /*           shell = pkgs.zsh; */
        /*         }; */
        /**/
        /*         home-manager.useGlobalPkgs = true; */
        /*         home-manager.users.${primaryUser.username} = { */
        /*           imports = attrValues self.homeManagerModules; */
        /*           home.stateVersion = homeStateVersion; */
        /*           #home.user-info = config.users.primaryUser; */
        /*           #home.user-info = primaryUser; */
        /*         }; */
        /*         nix.registry.my.flake = inputs.self; */
        /*       } */
        /*     ) */
        /*   ]; */
        /*   #inherit homeStateVersion; */
        /*   #homeModules = attrValues self.homeManagerModules; */
        /* }; */
      };
    } // flake-utils.lib.eachDefaultSystem (system: {
      # Re-export `nixpkgs-unstable` with overlays.
      # This is handy in combination with setting `nix.registry.my.flake = inputs.self`.
      # Allows doing things like `nix run my#prefmanager -- watch --all`
      legacyPackages = import inputs.nixpkgs-unstable (nixpkgsDefault // { inherit system; });
    });
}
