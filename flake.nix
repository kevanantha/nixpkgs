{
  description = "kevan's nix system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, flake-utils, darwin, deploy-rs, nixpkgs, nixpkgsUnstable, home-manager }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {

          devShell = with pkgs; pkgs.mkShell {
            buildInputs = [
              # Just in case :)
            ];
          };

        })
    // # <- concatenates Nix attribute sets
    {
      # TODO re-enable cachix across hosts

      homeConfigurations = {
        MEKARIs-MacBook-Pro-5 = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-darwin;
          modules = [ ./nixpkgs/home-manager/mac.nix ];
          extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-darwin; };
        };
      };

      darwinConfigurations = {
        # nix build .#darwinConfigurations.mbp2021.system
        # ./result/sw/bin/darwin-rebuild switch --flake .
        mbp2021 = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./nixpkgs/darwin/mbp2021/configuration.nix ];
          inputs = { inherit darwin nixpkgs; };
        };
      };

      images = {
        # nix build .#images.homepi
        homepi = self.nixosConfigurations.homepi.config.system.build.sdImage;
      };

      deploy.nodes = {
        # homepi = {
        #   # hostname = "192.168.1.8"; # local ip
        #   hostname = "homepi";
        #   profiles.system = {
        #     sshUser = "root";
        #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.homepi;
        #   };
        # };

        # dev2 = {
        #   hostname = "dev2";
        #   profiles.system = {
        #     sshUser = "root";
        #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.dev2;
        #   };
        # };

        # build-server = {
        #   hostname = "oracle-nix-builder";
        #   profiles.system = {
        #     sshUser = "root";
        #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.build-server;
        #   };
        # };
      };

      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      # common = {
      #   sshKeys = [
      #     "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLXMVzwr9BKB67NmxYDxedZC64/qWU6IvfTTh4HDdLaJe18NgmXh7mofkWjBtIy+2KJMMlB4uBRH4fwKviLXsSM= MBP2020@secretive.MacBook-Pro-Johannes.local"
      #     "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM7UIxnOjfmhXMzEDA1Z6WxjUllTYpxUyZvNFpS83uwKj+eSNuih6IAsN4QAIs9h4qOHuMKeTJqanXEanFmFjG0= MM2021@secretive.Johannes’s-Mac-mini.local"
      #     "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPkfRqtIP8Lc7qBlJO1CsBeb+OEZN87X+ZGGTfNFf8V588Dh/lgv7WEZ4O67hfHjHCNV8ZafsgYNxffi8bih+1Q= MBP2021@secretive.Johannes’s-MacBook-Pro.local"
      #   ];
      # };
    };
}
