{ ... }:

{
  imports = [
    ./htop.nix
    ./neofetch.nix
    ./tmux.nix
    #./urxvt.nix
    ./vim
  ];
  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
    manual.manpages.enable = true;
  };
  systemd.user.startServices = true;
}
