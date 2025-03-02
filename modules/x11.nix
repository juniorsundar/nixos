{ config, pkgs, ... }:

{
  services.libinput.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = [ "nvidia" ];
    desktopManager.xterm.enable = false;
    # Enable touchpad support (enabled default in most desktopManager).
    # windowManager.i3 = {
    #   enable = true;
    #   extraPackages = with pkgs; [ brightnessctl polybar nitrogen arandr xsel xclip rofi];
    # };
  };
}
