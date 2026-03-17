{ pkgs, lib, ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  
  programs.ssh.startAgent = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    playerctl
    pavucontrol
    xhost
    ulauncher

    gnome-tweaks
  ];

}
