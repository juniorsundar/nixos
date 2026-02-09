{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    playerctl
    pavucontrol

    # For X-Server only and forwarding
    xhost
    kdePackages.kcalc
  ];

  programs.kdeconnect.enable = true;
}
