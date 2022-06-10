 { config, pkgs, options, ... }:

{
  imports = [
    ./packages.nix
    ./python.nix
  ];
} 
