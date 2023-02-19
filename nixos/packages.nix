{ config, pkgs, options, ... }:

with pkgs;

let
  extensions = (with pkgs.vscode-extensions; [
    bbenoist.nix
    arrterian.nix-env-selector
    ms-python.python
    vscodevim.vim
    elmtooling.elm-ls-vscode
    eamodio.gitlens
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      { name = "vscode-pull-request-github";
        publisher = "GitHub";
        version = "0.55.2022112209";
        sha256 = "cN02GzmXKMkGWbo3LVJpWPD25ZxqdXqSeXSeMfD73fs=";
      }
      { name = "gatito-theme";
        publisher = "pawelgrzybek";
        version = "0.2.3";
        sha256 = "m2hUSShpxPerQZ7dnF6qRbB1kRo7/ZTF64tZ9iwhJFw=";
      }
      {
        name = "vscode-test-explorer";
        publisher = "hbenl";
        version = "2.21.1";
        sha256 = "fHyePd8fYPt7zPHBGiVmd8fRx+IM3/cSBCyiI/C0VAg=";
      }
      {
        name = "test-adapter-converter";
        publisher = "ms-vscode";
        version = "0.1.6";
        sha256 = "UC8tUe+JJ3r8nb9SsPlvVXw74W75JWjMifk39JClRF4=";
      }
    ];
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in
{
  
  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-pyjwt-1.7.1"
  ];

  environment.systemPackages = [ 
    _1password-gui
    cachix 
    google-chrome
    dbeaver
    docker
    elm2nix
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-live
    elmPackages.elm-test
    firefox
    git
    jq
    netlify-cli
    ngrok
    niv
    nixops_unstable
    nix-prefetch-git
    nix-prefetch-github
    nodejs
    postgresql
    python3Env
    signal-desktop
    tree
    unzip
    vim
    vscode-with-extensions
    whatsapp-for-linux
    wget
    xclip
    #xlibsWrapper
    xsel
    zip
  ];
}

