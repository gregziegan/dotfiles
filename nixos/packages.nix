{ config, pkgs, options, ... }:

with pkgs;

let
  extensions = (with pkgs.vscode-extensions; [
      nix
      ms-python.python
      vscodevim.vim
      elmtooling.elm-ls-vscode
    ])++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "0.1.2";
      sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
    }
  ];
  vscodium-with-extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = extensions;
  };
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscode;
    vscodeExtensions = extensions;
  };
in
{
  
  nixpkgs.config.permittedInsecurePackages = [
    "python2.7-pyjwt-1.7.1"
  ];
            
  environment.systemPackages = [ 
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
    ngrok
    niv
    nixops
    nix-prefetch-git
    nix-prefetch-github
    nodejs
    postgresql
    python3Env
    signal-desktop
    tree
    unzip
    vim 
    vscode 
    vscode-with-extensions
    wget
    xclip
    xlibsWrapper
    xsel
    zip
  ];
}

