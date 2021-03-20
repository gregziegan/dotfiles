let
  awsKeyId = "guillermo"; # symbolic name looked up in ~/.ec2-keys or a ~/.aws/credentials profile name
  region = "us-east-1";

  pkgs = import <nixpkgs> {};

  # We must declare an AWS Subnet for each Availability Zone
  # because Subnets cannot span AZs.
  subnets = [
    { name = "my-nixops-vpc-subnet-a"; cidr = "10.0.0.0/19"; zone = "${region}a"; }
    { name = "my-nixops-vpc-subnet-b"; cidr = "10.0.32.0/19"; zone = "${region}b"; }
    { name = "my-nixops-vpc-subnet-c"; cidr = "10.0.64.0/19"; zone = "${region}c"; }
  ];
in
{

  network.description = "A host for organizing efforts.";
  network.enableRollback = true;

  # Now follows a lot of AWS specific networking stuff that is required
  # to create a machine with Internet in a non-default-VPC.
  # Scroll past this unless you are interested in how to control
  # AWS specific stuff with NixOps.

  resources.ec2KeyPairs.my-key-pair = {
    accessKeyId = awsKeyId;
    inherit region;
  };

  resources.vpc.my-nixops-vpc = {
    accessKeyId = awsKeyId;
    inherit region;
    instanceTenancy = "default";
    enableDnsSupport = true;
    enableDnsHostnames = true;
    cidrBlock = "10.0.0.0/16";
    tags.Source = "NixOps";
  };

  resources.vpcSubnets =
    let
      makeSubnet = { cidr, zone }: { resources, ... }: {
        accessKeyId = awsKeyId;
        inherit region zone;
        vpcId = resources.vpc.my-nixops-vpc;
        cidrBlock = cidr;
        mapPublicIpOnLaunch = true;
        tags.Source = "NixOps";
      };
    in
      # We must declare a Subnet for each Availability Zone
      # because Subnets cannot span AZs.
      builtins.listToAttrs
        (map
          ({ name, cidr, zone }: pkgs.lib.nameValuePair name (makeSubnet { inherit cidr zone; }) )
          subnets
        );

  resources.ec2SecurityGroups.my-nixops-sg = { resources, lib, ... }: {
    accessKeyId = awsKeyId;
    inherit region;
    vpcId = resources.vpc.my-nixops-vpc;
    rules = [
      { toPort = 22; fromPort = 22; sourceIp = "0.0.0.0/0"; } # SSH
      { toPort = 80; fromPort = 80; sourceIp = "0.0.0.0/0"; } # HTTP
      { toPort = 443; fromPort = 443; sourceIp = "0.0.0.0/0"; } # HTTPS
    ];
  };

  resources.vpcRouteTables = {
    route-table = { resources, ... }: {
      accessKeyId = awsKeyId;
      inherit region;
      vpcId = resources.vpc.my-nixops-vpc;
    };
  };

  resources.vpcRoutes = {
    igw-route = { resources, ... }: {
      accessKeyId = awsKeyId;
      inherit region;
      routeTableId = resources.vpcRouteTables.route-table;
      destinationCidrBlock = "0.0.0.0/0";
      gatewayId = resources.vpcInternetGateways.my-nixops-igw;
    };
  };

  resources.vpcRouteTableAssociations =
    let
      association = subnetName: { resources, ... }: {
        accessKeyId = awsKeyId;
        inherit region;
        subnetId = resources.vpcSubnets."${subnetName}";
        routeTableId = resources.vpcRouteTables.route-table;
      };
    in
      builtins.listToAttrs
        (map
          ({ name, ... }: pkgs.lib.nameValuePair "association-${name}" (association name) )
          subnets
        );

  resources.vpcInternetGateways.my-nixops-igw = { resources, ... }: {
    accessKeyId = awsKeyId;
    inherit region;
    vpcId = resources.vpc.my-nixops-vpc;
  };

  # End of AWS-specific networking stuff.


  # Define a machine.
  # The key (`machine1`) will become the machine's host name.
  # The value is a function that
  #   * returns a NixOS machine configuration (which is just what you would
  #     write into a `configuration.nix` file for a single NixOS machine),
  #     augmented with some NixOps specific `deployment.*` attributes.
  #   * as arguments, takes some global info, such as `resources` that NixOps
  #     created in your AWS account, all the `nodes` in the network
  #     (only `nodes.machine1` exists in this network), and some other stuff
  #     ignored using `...`.
  #     This can be used to, for example, insert the IP of one machine into
  #     the config file of a service on another machine.
  machine1 = { resources, nodes, ... }: 
  let dnsName = "detainer-warrants.info";
      dnsName2 = "reddoorcollective.org";
  in
  {
    imports = [
      ./acme.nix

      ../../common/base.nix
      ../../common/services
    ];

    # Cloud provider settings; here for AWS
    deployment.targetEnv = "ec2";
    deployment.ec2.accessKeyId = awsKeyId; # symbolic name looked up in ~/.ec2-keys or a ~/.aws/credentials profile name
    deployment.ec2.region = region;
    deployment.ec2.instanceType = "t2.micro";
    deployment.ec2.ebsInitialRootDiskSize = 20; # GB
    deployment.ec2.keyPair = resources.ec2KeyPairs.my-key-pair;
    deployment.ec2.associatePublicIpAddress = true;
    deployment.ec2.subnetId = resources.vpcSubnets.my-nixops-vpc-subnet-a;
    deployment.ec2.securityGroups = []; # we don't want its default `[ "default" ]`
    deployment.ec2.securityGroupIds = [ resources.ec2SecurityGroups.my-nixops-sg.name ];

    # Packages available in SSH sessions to the machine
    environment.systemPackages = [
      pkgs.bind.dnsutils # for `dig` etc.
      pkgs.jq
      pkgs.vim
      pkgs.postgresql
      pkgs.tree
    ];

    networking.hostName = "guillermo";
    networking.firewall.allowedTCPPorts = [
      80 # HTTP
      443 # HTTPs
    ];

    system.stateVersion = "20.09"; # Did you read the comment?

    within.services = {
      eviction-tracker.enable = true;
    };

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_11;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
        CREATE DATABASE nixcloud;
        GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
      '';
    };

    services.nginx = {
      enable = true;
      virtualHosts.${dnsName} = {
        default = true;
        locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
        };
        addSSL = true;
        enableACME = true;
      };
    };

  };
}
