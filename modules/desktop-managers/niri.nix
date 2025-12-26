{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
  };
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = { };

  programs.waybar.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    playerctl
    pavucontrol

    waylock
    mako
    swayidle
    rofi

    xorg.xhost
  ];
}
