{ fetchFromGitHub ? (import <nixpkgs> { }).fetchFromGitHub }:

import (fetchFromGitHub ((builtins.fromJSON (builtins.readFile ./source.json))) + "/nix/serve_app.nix")
{ }