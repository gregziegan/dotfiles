let
  gziegan = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtH3Cw6EWNobPDEgf5OZX8Dpcn3L7YcCY+Ia4APet6v gziegan@tomlette"
  ];

  hosts = [
    # guillermo
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtH3Cw6EWNobPDEgf5OZX8Dpcn3L7YcCY+Ia4APet6v"
  ];

  publicKeys = gziegan ++ hosts;
in {
  "hosts/guillermo/secret/eviction-tracker.age".publicKeys = publicKeys;
}
