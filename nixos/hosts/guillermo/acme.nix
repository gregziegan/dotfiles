{ pkgs, ... }:

{
    security.acme.email = "greg.ziegan@gmail.com";
    security.acme.acceptTerms = true;

    security.acme.certs."detainer-warrants.info" = {
        group = "nginx";
        email = "greg.ziegan@gmail.com";
        dnsProvider = "namecheap";
    };
}