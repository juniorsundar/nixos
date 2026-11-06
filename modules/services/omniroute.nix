{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.omniroute;
  preStartScript = pkgs.writeShellScript "omniroute-prestart" ''
    set -euo pipefail

    install -d -m 0700 \
      '${cfg.dataDir}' \
      '${cfg.dataDir}/tmp' \
      '${cfg.dataDir}/.cache' \
      '${cfg.dataDir}/.config' \
      '${cfg.dataDir}/.local/share'
  '';
in
{
  options.services.omniroute = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable OmniRoute - Unified AI router with 160+ providers.";
    };

    # Newer OmniRoute versions may regress the dashboard/home UI. Upgrade
    # deliberately (see ./omniroute/package.nix) and verify login + /home.
    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ./omniroute/package.nix { };
      defaultText = literalExpression "pkgs.callPackage ./omniroute/package.nix { }";
      description = "OmniRoute package. It is read-only; all state lives in dataDir.";
    };

    port = mkOption {
      type = types.port;
      default = 20128;
      description = "The port for the OmniRoute API and dashboard.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/omniroute";
      description = "Directory for OmniRoute database, config, and credentials.";
    };

    requireApiKey = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to require an API key for all requests.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for the OmniRoute port.";
    };

    extraEnv = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Extra environment variables to pass to OmniRoute.";
      example = {
        HTTP_PROXY = "http://proxy:8080";
        HTTPS_PROXY = "http://proxy:8080";
      };
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra CLI flags to pass to omniroute.";
    };
  };

  config = mkIf cfg.enable {
    users.users.omniroute = {
      isSystemUser = true;
      group = "omniroute";
      home = cfg.dataDir;
      createHome = true;
      description = "OmniRoute service user";
    };

    users.groups.omniroute = { };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.omniroute = {
      description = "OmniRoute - Unified AI router";
      path = with pkgs; [
        nodejs_24 # the CLI spawns `node` from PATH; match the package's node
        bash
        coreutils
      ];
      documentation = [ "https://github.com/diegosouzapw/OmniRoute" ];
      after = [
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment =
        {
          PORT = toString cfg.port;
          DATA_DIR = cfg.dataDir;
          HOME = cfg.dataDir;
          XDG_CONFIG_HOME = "${cfg.dataDir}/.config";
          XDG_DATA_HOME = "${cfg.dataDir}/.local/share";
          XDG_CACHE_HOME = "${cfg.dataDir}/.cache";
          TMPDIR = "${cfg.dataDir}/tmp";
          REQUIRE_API_KEY = if cfg.requireApiKey then "true" else "false";
          NODE_ENV = "production";
          # Updates come from Nix, not `npm install -g`.
          NO_UPDATE_NOTIFIER = "1";
        }
        // cfg.extraEnv;

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 5;

        User = "omniroute";
        Group = "omniroute";

        RuntimeDirectory = "omniroute";
        RuntimeDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;

        # Security hardening
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        LockPersonality = true;

        ReadWritePaths = [ cfg.dataDir ];

        ExecStartPre = [ preStartScript ];

        ExecStart = "${getExe cfg.package} --no-open ${escapeShellArgs cfg.extraFlags}";
      };
    };
  };
}
