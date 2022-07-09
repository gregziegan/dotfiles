{ config, lib, pkgs, ... }:

{
  imports = [
    ./eviction_tracker.nix
  ];

  users.groups.within = {};
}