let
  pkgs = import <nixpkgs> {};
in
{
    networking.hostName = "tomlette";
    
    imports = [
      ../../common/base.nix
      ../../common/services
    ];

    #virtualisation.docker.enable = true;

    /*within.services = {
      eviction_tracker.enable = true;
    };*/

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_11;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
      '';
    };

    /*nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };*/
    
    services.logrotate.enable = false;

    nixpkgs.config.permittedInsecurePackages = [
      "python3.10-certifi-2022.9.24"
    ];

    nix.gc.automatic = true;
}