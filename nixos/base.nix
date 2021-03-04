 { config, pkgs, options, ... }:

{
  # Allow software with an unfree license
  nixpkgs.config.allowUnfree = true;

  # Set the JAVA_HOME environment variable
  programs.java.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
#  hardware.pulseaudio.enable = true;
#  hardware.pulseaudio.package = pkgs.pulseaudioFull;
#  nixpkgs.config.pulseaudio = true;
#  hardware.pulseaudio.systemWide = true;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the OpenSSH server.
  services.sshd.enable = true;

  nix.gc.automatic = true;
  nix.gc.dates = "06:15";

  # Start the docker daemon (also creates docker group)
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "20.03"; # Did you read the comment?
} 
