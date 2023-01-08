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
      "python2.7-certifi-2021.10.8"
      "python2.7-pyjwt-1.7.1"
      "python3.10-certifi-2022.12.7"
      "python3.9-poetry-1.1.14"
      "python3.9-certifi-2021.10.8"
    ];

    nix.gc.automatic = true;
}