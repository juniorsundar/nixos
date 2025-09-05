{ config, pkgs, ... }: {
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    playerctl
    pavucontrol
    xorg.xhost

    gnome-tweaks
  ];

}

