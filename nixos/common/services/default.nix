{ config, lib, pkgs, ... }:

{
  imports = [
    ./eviction-tracker.nix
  ];

  users.groups.within = {};
}