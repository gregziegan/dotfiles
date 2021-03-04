{ config, pkgs, ... }:

{
  users.users.gziegan = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" ];
    openssh.authorizedKeys.keys = [
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = config.users.users.gziegan.openssh.authorizedKeys.keys;

}
