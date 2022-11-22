pkgs: rec {
    github.com = {
        red-door-collective.eviction-tracker = pkgs.callPackage ./github.com/red-door-collective/eviction-tracker { };
        red-door-collective.eviction-tracker-static-files = pkgs.callPackage ./github.com/red-door-collective/eviction-tracker/static_files.nix { };
    };
}

