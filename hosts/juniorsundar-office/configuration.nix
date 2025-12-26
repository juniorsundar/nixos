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
  ];

}
