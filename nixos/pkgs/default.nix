pkgs: rec {
    github.com = {
        thebritican.eviction-tracker = pkgs.callPackage ./github.com/thebritican/eviction-tracker { };
    };
}

