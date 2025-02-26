{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    xkb.layout = "us";
    desktopManager.xterm.enable = false;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ brightnessctl polybar rofi nitrogen ];
    };
  };
}
