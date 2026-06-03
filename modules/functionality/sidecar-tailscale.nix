{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.tailscale-sidecar;
in
{
  options.services.tailscale-sidecar = {
    package = mkPackageOption pkgs "tailscale" { };

    port = mkOption {
      type = types.port;
      default = 41642;
      description = "The port for the sidecar tailscaled to listen on.";
    };

    interfaceName = mkOption {
      type = types.str;
      default = "tailscale1";
      description = "TUN interface name for the sidecar.";
    };

    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/tailscale-sidecar";
      description = "State directory for the sidecar instance.";
    };

    extraDaemonFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra flags to pass to tailscaled.";
    };

    extraSetFlags = mkOption {
      type = types.listOf types.str;
      default = [
        "--netfilter-mode=off"
        "--accept-dns=false"
      ];
      example = [
        "--netfilter-mode=off"
        "--accept-dns=false"
        "--advertise-exit-node"
      ];
      description = ''
        Extra flags to pass to `tailscale set` on the sidecar.
        Defaults to `--netfilter-mode=off` to prevent the sidecar from wiping
        the primary instance's firewall rules, and `--accept-dns=false` to
        prevent the sidecar from overriding DNS and blocking other DNS
        sources (e.g. a VPN) via resolvconf exclusivity.
      '';
    };
  };

  config = {
    environment.systemPackages = [
      cfg.package
      pkgs.iptables
      pkgs.nftables
      (pkgs.writeShellScriptBin "tailscale2" ''
        exec ${lib.getExe cfg.package} --socket=/run/tailscale-sidecar/tailscaled.sock "$@"
      '')
    ];
    networking.firewall.trustedInterfaces = [ cfg.interfaceName ];
    networking.firewall.checkReversePath = false;

    # --- systemd service for the sidecar tailscaled ---
    systemd.services.tailscaled-sidecar = {
      description = "Tailscale sidecar daemon";
      documentation = [ "https://tailscale.com/kb/" ];
      after = [
        "network-pre.target"
        "tailscaled.service"
      ]
      ++ lib.optionals config.networking.networkmanager.enable [ "NetworkManager-wait-online.service" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [
        pkgs.kmod
        pkgs.procps
        pkgs.getent
      ]
      ++ lib.optional config.networking.resolvconf.enable config.networking.resolvconf.package;

      serviceConfig = {
        Type = "notify";
        Restart = "on-failure";
        StateDirectory = "tailscale-sidecar";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "tailscale-sidecar";
        RuntimeDirectoryMode = "0755";
        CacheDirectory = "tailscale-sidecar";
        CacheDirectoryMode = "0750";

        Environment = [
          "PORT=${toString cfg.port}"
          "TS_STATE_DIR=${cfg.stateDir}"
          "TS_FWMARK=52221" # Add this line to separate routing
        ];

        ExecStart = "${cfg.package}/bin/tailscaled --statedir=${cfg.stateDir} --socket=/run/tailscale-sidecar/tailscaled.sock --tun ${cfg.interfaceName} --port=${toString cfg.port} ${lib.concatStringsSep " " cfg.extraDaemonFlags}";
        ExecStopPost = "${cfg.package}/bin/tailscaled --cleanup --statedir=${cfg.stateDir} --socket=/run/tailscale-sidecar/tailscaled.sock --tun ${cfg.interfaceName}";
      };
    };

    # --- Oneshot to apply tailscale set flags ---
    systemd.services.tailscaled-sidecar-set = mkIf (cfg.extraSetFlags != [ ]) {
      requires = [ "tailscaled-sidecar.service" ];
      after = [ "tailscaled-sidecar.service" ];
      wants = [ "tailscaled-sidecar.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        ${lib.getExe cfg.package} \
          --socket=/run/tailscale-sidecar/tailscaled.sock \
          set ${escapeShellArgs cfg.extraSetFlags}
      '';
    };

    # --- Don't let dhcpcd manage the sidecar TUN ---
    networking.dhcpcd.denyInterfaces = [ cfg.interfaceName ];
    systemd.services.tailscaled-sidecar-firewall = {
      description = "Allow Tailscale sidecar interface through Tailscale firewall chain";

      after = [
        "tailscaled.service"
        "tailscaled-sidecar.service"
      ];

      requires = [
        "tailscaled-sidecar.service"
      ];

      wantedBy = [ "multi-user.target" ];

      path = [
        pkgs.iptables
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        # If the primary tailscaled hasn't created ts-input (it may use a
        # different firewall backend, or the chain was flushed during
        # nixos-rebuild without tailscaled being restarted), skip gracefully.
        iptables -L ts-input >/dev/null 2>&1 || exit 0
        iptables -C ts-input -i ${escapeShellArg cfg.interfaceName} -j ACCEPT 2>/dev/null \
          || iptables -I ts-input 1 -i ${escapeShellArg cfg.interfaceName} -j ACCEPT
      '';
    };
    # If systemd-networkd is used, mark the sidecar TUN as unmanaged
    systemd.network.networks."50-tailscale-sidecar" = mkIf config.networking.useNetworkd {
      matchConfig = {
        Name = cfg.interfaceName;
      };
      linkConfig = {
        Unmanaged = true;
        ActivationPolicy = "manual";
      };
    };
  };
}
