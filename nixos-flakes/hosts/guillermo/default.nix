{ config, lib, domain, pkgs, ... }:

let
  region = "us-east-1";
  accessKeyId = "default";
in {
  # networking.description = "reddoorcollective.org"; # Optional description

  imports = [
      ./ec2-info.nix
   ];

  deployment.targetEnv = "ec2";
  deployment.ec2.region = "us-east-1";
  deployment.ec2.instanceType = "t2.micro";

  within.users.enableSystem = true;
  services.openssh.enable = true;
    
}