{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pi-web;
  version = "0.15.0";

  # Upstream's `next build` fetches Google Fonts, which the Nix sandbox forbids.
  # So: dependencies come from the GitHub source (package-lock.json) and the
  # prebuilt `.next` comes from the npm tarball, which is what `npx` runs.
  npmTarball = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@agegr/pi-web/-/pi-web-${version}.tgz";
    hash = "sha256-4VCI9UU/R825RpNfA6iU0CEdyALiuiQCOObXWRNsCvc=";
  };

  pi-web = pkgs.buildNpmPackage {
    pname = "pi-web";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "agegr";
      repo = "pi-web";
      rev = "v${version}";
      hash = "sha256-EUa1w0HP5J45yNRGYLtP401q+mjyRjcq9FWhy+++wxk=";
    };
    npmDepsHash = "sha256-7WD1AsVs7s5XAbZY/Vr3YNshCFwMzvP2v513f3Shf7c=";

    nodejs = pkgs.nodejs_22;
    npmFlags = [ "--ignore-scripts" ]; # node-pty ships prebuilds; postinstall only fixes macOS
    dontNpmBuild = true;
    dontNpmInstall = true;

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [
      pkgs.stdenv.cc.cc.lib
      pkgs.libxcb # pi-tui X11 clipboard module
    ];

    installPhase = ''
      runHook preInstall
      tar xzf ${npmTarball} --one-top-level=tarball --strip-components=1
      rm -rf node_modules/.cache
      npm prune --omit=dev --offline --ignore-scripts
      mkdir -p $out/lib/pi-web
      cp -r bin public package.json next.config.ts node_modules $out/lib/pi-web/
      cp -r tarball/.next $out/lib/pi-web/.next
      mkdir -p $out/bin
      ln -s $out/lib/pi-web/bin/pi-web.js $out/bin/pi-web
      runHook postInstall
    '';

    meta = {
      description = "Web UI for the pi coding agent";
      homepage = "https://github.com/agegr/pi-web";
      license = lib.licenses.mit;
      mainProgram = "pi-web";
    };
  };

  # bin/pi-web.js rewrites .next/prerender-manifest.json at startup (it must be
  # writable or the auth proxy can be bypassed), and the store is read-only.
  # Keep a writable copy of .next in the state dir; everything else is symlinked.
  # bin/ is copied (not linked) so __dirname resolves inside the state dir.
  prepare = pkgs.writeShellScript "pi-web-prepare" ''
    set -eu
    d=$STATE_DIRECTORY/app
    rm -rf "$d"
    mkdir -p "$d"
    cp -r ${pi-web}/lib/pi-web/.next ${pi-web}/lib/pi-web/bin "$d/"
    chmod -R u+w "$d"
    for f in node_modules public package.json next.config.ts; do
      ln -s ${pi-web}/lib/pi-web/$f "$d/$f"
    done
  '';
in
{
  options.services.pi-web = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true; # importing the module is enough to turn it on
      description = "Whether to run pi-web, a web UI for the pi coding agent.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "juniorsundar";
      description = "User to run as. Its ~/.pi/agent holds the sessions and credentials.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address to bind.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 30141;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the port in the firewall. pi-web gives shell access, so prefer a VPN (e.g. tailscale0).";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pi-web ];
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.pi-web = {
      description = "pi-web - web UI for the pi coding agent";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      # bash and git are used by the agent's shell tool, terminal and git features.
      # The system profile comes last so MCP servers configured with
      # `uvx`/`npx` resolve the same tools a login shell sees (systemd appends /bin).
      path = (with pkgs; [
        bash
        coreutils
        git
        nodejs_22
      ]) ++ [ "/run/current-system/sw" ];
      environment = {
        NODE_ENV = "production";
        NEXT_TELEMETRY_DISABLED = "1";
        PI_WEB_NO_OPEN = "1";
        PI_WEB_SKIP_VERSION_CHECK = "1";
        HOME = config.users.users.${cfg.user}.home;
      };
      serviceConfig = {
        User = cfg.user;
        StateDirectory = "pi-web";
        WorkingDirectory = config.users.users.${cfg.user}.home;
        ExecStartPre = prepare;
        ExecStart = "${pkgs.nodejs_22}/bin/node %S/pi-web/app/bin/pi-web.js -H ${cfg.host} -p ${toString cfg.port}";
        Restart = "on-failure";
        RestartSec = 5;
        # Must stay a string: a Nix path literal would be copied into the world-readable store.
        # Create it yourself (root:root 0600, `PI_WEB_PASSWORD=...`); the unit fails to start without it.
        # sudo install -m 0600 -o root -g root /dev/null /etc/pi-web.env
        # sudo sh -c 'echo "PI_WEB_PASSWORD=your-password-here" > /etc/pi-web.env'
        EnvironmentFile = "/etc/pi-web.env";
      };
    };
  };
}
