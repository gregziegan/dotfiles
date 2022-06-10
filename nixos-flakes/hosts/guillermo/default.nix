let
  region = "us-east-1";
  accessKeyId = "prod";
in {
  network.description = "reddoorcollective.org"; # Optional description

   machine =
    { imports = [ ./ec2-info.nix ];
      deployment.targetEnv = "ec2";
      deployment.ec2.region = "us-east-1";
      deployment.ec2.instanceType = "t2.micro";
    };
}