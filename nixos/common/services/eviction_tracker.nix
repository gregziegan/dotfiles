{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.within.services.eviction_tracker;
in {
    options.within.services.eviction_tracker = {
        enable = mkEnableOption "Starts court data site";

        port = mkOption {
            type = types.port;
            default = 8080;
            example = 9001;
            description = "The port number eviction_tracker should listen on for HTTP traffic";
        };

        domain = mkOption {
            type = types.str;
            default = "reddoorcollective.org";
            example = "reddoorcollective.org";
            description =
                "The domain name that nginx should check against for HTTP hostnames";
        };

        secrets = mkOption {
            type = types.path;
            default = ./eviction_tracker/secrets/production.env;
            example = ./eviction_tracker/secrets/production.env;
            description = "Where to find the secrets for this environment";
        };

        db = mkOption {
            type = types.str;
            default = "eviction_tracker";
            example = "eviction_tracker";
            description = "The database name";
        };

        logDir = mkOption {
            type = types.path;
            default = "/var/log/eviction_tracker";
            description = ''
                Directory for storing Eviction Tracker access logs.
                <note><para>
                If left as the default value this directory will automatically be created
                before the server starts, otherwise the sysadmin is responsible for
                ensuring the directory exists with appropriate ownership and permissions.
                </para></note>
            '';
        };
    };

    config = lib.mkIf cfg.enable {

        users.users.eviction_tracker = {
            createHome = true;
            description = "github.com/red-door-collective/eviction-tracker";
            isSystemUser = true;
            group = "within";
            home = "/srv/within/eviction_tracker";
            extraGroups = [ "keys" ];
        };

        within.secrets.eviction_tracker = {
            source = cfg.secrets;
            dest = "/srv/within/eviction_tracker/.env";
            owner = "eviction_tracker";
            group = "within";
            permissions = "0440";
        };

        within.secrets.eviction_tracker-google-service-account = {
            source = ./eviction_tracker/secrets/google_service_account.json;
            dest = "/srv/within/eviction_tracker/google_service_account.json";
            owner = "eviction_tracker";
            group = "within";
            permissions = "0440";
        };
        
        networking.firewall.allowedTCPPorts = [ cfg.port ];

        systemd.services.eviction_tracker = {
            description = "A webapp that presents and verifies court data";

            wantedBy = [ "multi-user.target" ];

            after = [ "eviction_tracker-key.service" "postgresql.service" ];
            wants = [ "eviction_tracker-key.service" "postgresql.service" ];

            serviceConfig = {
                User = "eviction_tracker";
                Group = "within";
                Restart = "on-failure";
                WorkingDirectory = "/srv/within/eviction_tracker";
                LogsDirectory = mkIf (cfg.logDir == "/var/log/eviction_tracker") ["eviction_tracker"];
                RestartSec = "30s";

                # Security
                #CapabilityBoundingSet = "";
                #DeviceAllow = [ ];
                #NoNewPrivileges = "true";
                #ProtectControlGroups = "true";
                #ProtectClock = "true";
                #PrivateDevices = "true";
                #PrivateUsers = "true";
                #ProtectHome = "true";
                #ProtectHostname = "true";
                #ProtectKernelLogs = "true";
                #ProtectKernelModules = "true";
                #ProtectKernelTunables = "true";
                #ProtectSystem = "true";
                #ProtectProc = "invisible";
                #RemoveIPC = "true";
                #RestrictSUIDSGID = "true";
                #RestrictRealtime = "true";
                #SystemCallArchitectures = "native";
                #SystemCallFilter = [
                #    "~@reboot"
                #    "~@module"
                #    "~@mount"
                #    "~@swap"
                #    "~@resources"
                #    "~@cpu-emulation"
                #    "~@obsolete"
                #    "~@debug"
                #    "~@privileged"
                #];
                #UMask = "077";
            };

            script = let site = pkgs.github.com.red-door-collective.eviction-tracker;
            staticFiles = pkgs.github.com.red-door-collective.eviction-tracker-static-files;
            in ''
              # ln -s ${staticFiles}/static_pages /srv/within/eviction_tracker/static

              mkdir -p /var/www/eviction_tracker
              chmod -R 775 /var/www/eviction_tracker
              rm -rf /var/www/eviction_tracker/static
              cp -r ${staticFiles}/static_pages /var/www/eviction_tracker/static
              chmod -R 775 /var/www/eviction_tracker/static
              export $(cat /srv/within/eviction_tracker/.env | xargs)
              export FLASK_APP="eviction_tracker.app"
              ${site}/bin/migrate
              export FLASK_APP="eviction_tracker"
              ${site}/bin/run
            '';
        };
    };
}
