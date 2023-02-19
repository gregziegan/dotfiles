{ config, pkgs, ... }:

{
  users.users.gziegan = {
    isNormalUser = true;
    description = "Greg Ziegan";
    extraGroups =
      [ "networkmanager" "wheel" "docker" ];
     openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+rjm0IVQ/3a5RXjZBsO0iLok3SgkS3oB7Vy7yLHvnp"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ+rUSe4gXmVlP4vW9l95ATHMzj3I630XT+Rz325KgCy"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrwG4DFPi7l4K6yqIJxXILnzt7w9SDqFbB/af/5h/VUvo31FeWhfCTpshtudestM0kS6Or/l2Hmhllz3pGW/cVeFG7mYjqm64I+Z0Gej+F8BE8MgjdI3/E2cSHQjdsMMng8yLHemyvvDTqO1Vn6oFb5arOyK/A6dDsPJpcsy6L9wpXc8HD2YY5iaTj5Juyewb9uhOd1wJEhnydiuguMvnk+M5w40cJczNIhVB5eXpHACZDj5sSwYs2umydSAYGfYxe0ltlu7FrzyTbAIZGaAEkB86lDK2d1Y6w4m0++xmRpdQRB3E/D6V0maPAauMTYJJlLDnfyBepxbD3+k0O5D3VRCgI8cG7fDIXLwPjOpWcribsXJQ3MusoFe61s+BU3dRJt6rAa2JPeF8H/HstRDTbsPHH0meaL/4tcTyn9N3HTGr0faxl1QMseoxU6aqWRQCgdvehWl7zinXouyN1jFvRctO/BBtmx+skJnXU+DLHvWVbj5PWMwRZZikpNjRVMUk="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKU6+/YRj+s5oPA+8q9ZCuzYW6/rbS0X6pvv8VQ7rHnD"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9tF22Z1088OdLpYwwdaLCMF+Kg94nt2Ddbt08qdH7C"
    ];
  };

  users.users.datadog = {
    extraGroups = [ "within" ];
    isNormalUser = true;
  };

  users.users.root.openssh.authorizedKeys.keys = config.users.users.gziegan.openssh.authorizedKeys.keys;

}
