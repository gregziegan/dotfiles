let
  pkgs = import <nixpkgs> { };
  myPkgs = (import ./.) pkgs;
in rec {
  inherit (myPkgs) github;

  eviction-tracker = github.com.red-door-collective.eviction-tracker;

}