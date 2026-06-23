{ pkgs, ... }:
{
  imports = [ ../../common/workstation.nix ];

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
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
    firewall.trustedInterfaces = [ "wlp0s20f3" ];
    # firewall.allowedTCPPorts = [ 8080 ];
  };

  # Stop the main tailscale from managing DNS (the sidecar already has
  # --accept-dns=false in its defaults).  Otherwise tailscale's resolvconf
  # exclusivity blocks the VPN DNS servers pushed via NetworkManager.
  services.tailscale.extraSetFlags = [ "--accept-dns=false" ];

  services = {
    # OmniRoute is installed externally under /opt/omniroute and managed by
    # modules/services/omniroute.nix. Keep the external install version in sync
    # with the note in that module.
    flatpak.packages = [
      {
        appId = "com.prusa3d.PrusaSlicer";
        origin = "flathub";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    microsoft-edge
    picocom
    slack
    teams-for-linux
    # devcontainer
  ];
  programs.qgroundcontrol.enable = true;

}
