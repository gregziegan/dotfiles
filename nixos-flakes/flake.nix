{
  description = "My deploy-rs config for guillermo";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    # my apps
    #eviction-tracker = {
    #  url = "github:red-door-collective/eviction-tracker";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.utils.follows = "utils";
    #};
  };

  outputs = { self, nixpkgs, deploy-rs, home-manager, agenix#, eviction-tracker 
    , ... }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

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
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          deploy-rs.packages.x86_64-linux.deploy-rs
          agenix.packages.x86_64-linux.agenix
        ];
      };

      nixosConfigurations = {
        # cloud
        guillermo = mkSystem [ ./hosts/guillermo ./hardware/location/YYZ ];
      };

      deploy.nodes.guillermo = {
        hostname = "149.248.59.1";
        sshUser = "root";

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.guillermo;
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
