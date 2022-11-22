{ fetchFromGitHub ? (import <nixpkgs> { }).fetchFromGitHub, lib, pkgs, config }:

import (fetchFromGitHub ((builtins.fromJSON (builtins.readFile ./source.json))) + "/nix/serve_app.nix") { }