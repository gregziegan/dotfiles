{ config, pkgs, options, ... }:

with pkgs;

let
  extensions = (with pkgs.vscode-extensions; [
      bbenoist.Nix
      ms-python.python
      ms-azuretools.vscode-docker
      justusadam.language-haskell
      haskell.haskell
      vscodevim.vim
    ])++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "vscode-direnv";
      publisher = "Rubymaniac";
      version = "0.0.2";
      sha256 = "1gml41bc77qlydnvk1rkaiv95rwprzqgj895kxllqy4ps8ly6nsd";
    }
  ];
  vscodium-with-extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = extensions;
  };
in
{

  # Packages I want to use
  environment.systemPackages = [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    auctex
    bash
    bibclean
    bibutils
    bind # for dig
    binutils-unwrapped
    cabal-install
    cabal2nix
    cachix
    cairo
    calibre
    chromium
    coolreader
    csvkit
    curl
    cvc4
    diff-pdf
    direnv
    dmenu
    dmidecode # system hardware info
    docker
    dos2unix
    dzen2
    evince
    fbreader
    file
    firefox
    font-awesome
    fzy
    ghc
    ghostscript # for pdf2dsc
    gitAndTools.gitFull
    gitit
    git-lfs
    gimp
    gmp # GNU multiple precision arithmetic library
    gnome3.adwaita-icon-theme # to help meld?
    gnome3.dconf
    gnome3.dconf-editor
    gnome3.eog
    gnome3.gnome-disk-utility
    gnome3.gucharmap
    gnome3.meld
    gnumake
    gnupg
    gnutls
    gparted
    graphviz
    haskellPackages.hoogle
    haskellPackages.turtle
    # hdf5
    # hdfview
    hplip
    hplipWithPlugin
    imagemagick
    inkscape
    iosevka # font
    ispell
    jdk
    jq # json processor
    jupyter
    # kdeApplications.okular
    # kdeApplications.spectacle # replaced ksnapshot
    # kdeconnect
    lftp
    libertine
    libreoffice
    lorri
    gnome3.librsvg # for rsvg-convert
    lsof
    lxqt.lximage-qt
    lxqt.qterminal
    memtester
    mkpasswd
    mupdf
    ncompress
    niv
    nixops
    nix-index # provides nix-locate
    nix-prefetch-git
    offlineimap
    openjdk
    p7zip
    pandoc
    pasystray # audio
    pavucontrol # audio
    pciutils # audio (lspci)
    pdfgrep
    pdfmod
    pdftk
    pkgconfig
    python
    python3Env
    qpdf
    qpdfview
    rsync
    shake
    signal-desktop
    spotifyd
    spotify-tui
    sxiv
    tabula # extract tables from PDF files
    telnet
    texstudio
    texlive.combined.scheme-full
    tree
    ugrep
    unrar
    unzip
    usbutils
    vim
    vistafonts # True-type fonts from MS Windows
    vlc
    vscodium-with-extensions
    wget
    wpa_supplicant
    xclip
    x11
    xmlstarlet # A command line tool for manipulating and querying XML data
    xmonad-with-packages
    xorg.libX11
    xorg.xev
    xscreensaver
    xsel
    zip
  ];
}
