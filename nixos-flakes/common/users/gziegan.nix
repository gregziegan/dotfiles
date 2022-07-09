{ config, pkgs, ... }:

{
  users.users.gziegan = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "audio" "within" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+rjm0IVQ/3a5RXjZBsO0iLok3SgkS3oB7Vy7yLHvnp"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = config.users.users.gziegan.openssh.authorizedKeys.keys;
  home-manager.users.gziegan = (import ./gziegan);
}
