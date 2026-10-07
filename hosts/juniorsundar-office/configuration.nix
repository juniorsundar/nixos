{ pkgs, ... }:
{
  imports = [ ../../common/workstation.nix ];

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
        networkmanager-openvpn
      ];

      # Keep Tailscale MagicDNS available while letting resolvconf merge in
      # VPN DNS servers (GlobalProtect pushes 10.161.10.11/12). By default
      # Tailscale sets itself exclusive in resolvconf, which drops all other
      # DNS sources.  We disable DNS management on both tailscale instances
      # and add MagicDNS explicitly via NetworkManager.
      appendNameservers = [ "100.100.100.100" ];
    };
    hostName = "juniorsundar-office";
    # wireless.enable = true;
    firewall.trustedInterfaces = [
      "wlp0s20f3"
      "enp37s0u2u1u2"
    ];
    # firewall.allowedTCPPorts = [ 8080 ];
  };

  # Stop the main tailscale from managing DNS (the sidecar already has
  # --accept-dns=false in its defaults).  Otherwise tailscale's resolvconf
  # exclusivity blocks the VPN DNS servers pushed via NetworkManager.
  services.tailscale.extraSetFlags = [ "--accept-dns=false" ];

  services = {
    flatpak.packages = [
      {
        appId = "com.prusa3d.PrusaSlicer";
        origin = "flathub";
      }
    ];
  };

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
  users.users.juniorsundar.extraGroups = [ "tss" ];

  environment.systemPackages = with pkgs; [
    microsoft-edge
    picocom
    slack
    teams-for-linux
    claude-code
    # devcontainer

    usbutils
    cryptsetup
    e2fsprogs
    util-linux

    tpm2-tools
    opensc
    softhsm
  ];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-cli;
  };

  programs.qgroundcontrol = {
    enable = true;
    # GCC 16 + upstream -Werror breaks 4.4.5; drop once nixpkgs fixes it.
    package = pkgs.qgroundcontrol.overrideAttrs (old: {
      env = (old.env or { }) // {
        NIX_CFLAGS_COMPILE = toString [
          (old.env.NIX_CFLAGS_COMPILE or "")
          "-Wno-error=unused-but-set-variable"
        ];
      };
    });
  };

}
