{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = [ "nvidia" ];
    displayManager.lightdm.enable = true;
    desktopManager.xterm.enable = false;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ brightnessctl polybar rofi nitrogen ];
    };
  };
}
