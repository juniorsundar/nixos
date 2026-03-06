{ pkgs, ... }:
{
  imports = [ ../../common/workstation.nix ];

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
    };
    hostName = "juniorsundar-office";
    # wireless.enable = true;
    firewall.trustedInterfaces = [ "wlp0s20f3" ];
    # firewall.allowedTCPPorts = [ 8080 ];
  };

  services = {
    flatpak.packages = [
      {
        appId = "com.prusa3d.PrusaSlicer";
        origin = "flathub";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    microsoft-edge
    # devcontainer
  ];
  programs.qgroundcontrol.enable = true;

}
