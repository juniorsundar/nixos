{
  config,
  lib,
  pkgs,
  inputs,
  options,
  _class,
  ...
}:
let
  paseoPkgs = inputs.paseo.packages.${pkgs.stdenv.hostPlatform.system};
  hmUsers = lib.attrNames (config.home-manager.users or { });
  hmUser = lib.head hmUsers;
in
{
  # Works as both a NixOS and a home-manager module.
  # `imports` can't look at `options` (infinite recursion), so it keys off the module class.
  imports = lib.optional (_class == "nixos") inputs.paseo.nixosModules.default;

  # Keys under `config` are chosen lazily to avoid infinite recursion on `options`.
  config =
    if options ? home then
      {
        home.packages = [
          paseoPkgs.default
          paseoPkgs.desktop
        ];

        # Equivalent of upstream's NixOS service (services.paseo), for non-NixOS hosts.
        # PASEO_HOME matches the CLI and desktop app, so they attach to this daemon.
        systemd.user.services.paseo = {
          Unit = {
            Description = "Paseo - self-hosted daemon for AI coding agents";
            After = [ "network.target" ];
          };
          Service = {
            ExecStart = "${paseoPkgs.default}/bin/paseo-server";
            Environment = [
              "PASEO_HOME=${config.home.homeDirectory}/.paseo"
              "PASEO_LISTEN=127.0.0.1:6767"
              # Agents the daemon spawns need the user's CLIs (claude, codex, git, ...).
              "PATH=${config.home.profileDirectory}/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin"
            ];
            Restart = "on-failure";
            RestartSec = 5;
            TimeoutStopSec = 15;
          };
          Install.WantedBy = [ "default.target" ];
        };
      }
    else
      {
        # Run as the host's single home-manager user so the daemon shares ~/.paseo with
        # the CLI/desktop app and agents see the user's tools. Otherwise fall back to
        # upstream's `paseo` system user. Hosts can still override services.paseo.user.
        services.paseo = {
          enable = true;
          user = lib.mkIf (lib.length hmUsers == 1) (lib.mkDefault hmUser);
          group = lib.mkIf (lib.length hmUsers == 1) (
            lib.mkDefault config.users.users.${hmUser}.group
          );
        };
        environment.systemPackages = [ paseoPkgs.desktop ];
      };
}
