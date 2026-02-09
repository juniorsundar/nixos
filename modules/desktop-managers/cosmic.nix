{ pkgs, ... }:
{
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    playerctl
    pavucontrol
    # For X-Server only and forwarding
    xhost
    kdePackages.okular
  ];
}
