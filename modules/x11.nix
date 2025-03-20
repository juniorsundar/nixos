{
  config,
  pkgs,
  ...
}: {
  services.libinput.enable = true;

  services.xserver = {
    displayManager.gdm = {
      enable = true;
    };

    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = ["nvidia"];
    desktopManager.xterm.enable = false;

    # Enable touchpad support (enabled default in most desktopManager).
    # windowManager.i3 = {
    #   enable = true;
    #   extraPackages = with pkgs; [ brightnessctl polybar nitrogen arandr xsel xclip rofi];
    # };
  };
}
