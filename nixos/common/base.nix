{ config, lib, pkgs, ... }:

with lib; {
  imports = [
    ./users
    ./crypto
  ];

  options.gziegan = {
    gui.enable = mkEnableOption "Enables GUI programs";

    git = {
      name = mkOption rec {
        type = types.str;
        default = "Greg Ziegan";
        example = default;
        description = "Name to use with git commits";
      };
      email = mkOption rec {
        type = types.str;
        default = "greg.ziegan@gmail.com";
        example = default;
        description = "Email to use with git commits";
      };
    };
  };

  config = {
    boot.cleanTmpDir = true;

    environment.systemPackages = with pkgs; [ age minisign ];

    nix = {
      autoOptimiseStore = true;
      useSandbox = false;

      binaryCaches = [ "https://midtndsa.cachix.org" ];
      binaryCachePublicKeys =
        [ "" ];

      trustedUsers = [ "root" "gziegan" ];
    };

    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = import ../pkgs;
    };

    security.pam.loginLimits = [{
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "unlimited";
    }];

    users.groups.within = { };

    services.journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=7day
    '';

    systemd.services.within-homedir-setup = {
      description = "Creates homedirs for /srv/within services";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        ${coreutils}/bin/mkdir -p /srv/within
        ${coreutils}/bin/chown root:within /srv/within
        ${coreutils}/bin/chmod 775 /srv/within
      '';
    };
  };
}
