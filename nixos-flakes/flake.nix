{
  description = "My config for guillermo";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixops-plugged.url = "github:lukebfox/nixops-plugged";
    utils.url = "github:numtide/flake-utils";

    # my apps
    #eviction-tracker = {
    #  url = "github:red-door-collective/eviction-tracker";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.utils.follows = "utils";
    #};
  };

  outputs = { self, nixpkgs, nixops-plugged, home-manager, agenix#, eviction-tracker 
    , utils, ... }: let
      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [self.overlay];
      };
      domain = "reddoorcollective.org";
    in {
      nixopsConfigurations.default = {
        inherit nixpkgs;
        network.description = domain;
        defaults.nixpkgs.pkgs = pkgsFor "x86_64-linux";
        defaults._module.args = {
          inherit domain;
        };
        webserver = import ./hosts/guillermo;
      };
    } 
    // utils.lib.eachDefaultSystem (system: 
    let
      pkgs = import nixpkgs { inherit system; };

      mkSystem = extraModules:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager

            ({ config, ... }: {
              system.configurationRevision = self.sourceInfo.rev;
              services.getty.greetingLine =
                "<<< Welcome to NixOS ${config.system.nixos.label} @ ${self.sourceInfo.rev} - \\l >>>";

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            })
            ./common

            # eviction-tracker.nixosModules.${system}.bot
          ] ++ extraModules;
        };
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [
          nixops-plugged.defaultPackage.${system} 
          agenix.packages.${system}.agenix
        ];
      };

      /*nixopsConfigurations.default = {
        inherit nixpkgs;
        network.storage.legacy.databasefile = "~/.nixops/deployments.nixops";
        network.description = domain;
        network.enableRollback = true;
        defaults.nixpkgs.pkgs = pkgs;
        defaults._module.args = {
          inherit domain;
        };

         guillermo = import ./hosts/guillermo.nix;

      };*/

      nixosConfigurations = {
        # cloud
        guillermo = mkSystem [ ./hosts/guillermo ];
      };

      deploy.nodes.guillermo = {
        hostname = "149.248.59.1";
        sshUser = "root";

        profiles.system = {
          user = "root";
          path = self.nixosConfigurations.guillermo;
        };
      };
    });
}
