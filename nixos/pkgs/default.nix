pkgs: rec {
    github.com = {
        red-door-collective.eviction-tracker = pkgs.callPackage ./github.com/red-door-collective/eviction-tracker { };
    };
}

