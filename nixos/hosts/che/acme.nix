{ pkgs, ... }:

{
    security.acme.defaults.email = "greg.ziegan@gmail.com";
    security.acme.acceptTerms = true;

}