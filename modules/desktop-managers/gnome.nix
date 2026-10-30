{ pkgs, lib, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  
  programs.ssh.startAgent = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    xclip
    playerctl
    pavucontrol
    xhost

    gnomeExtensions.pop-shell
    gnomeExtensions.dash-to-dock
    gnome-tweaks
  ];

}
