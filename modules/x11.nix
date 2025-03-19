{
  config,
  pkgs,
  ...
}: {
  services.libinput.enable = true;
  # Enable the X11 windowing system.
  programs.dconf.enable = true;
  services.xserver = {
  };

  environment.gnome.excludePackages = with pkgs; [
    orca
    evince
    # file-roller
    geary
    gnome-disk-utility
    # seahorse
    # sushi
    # sysprof
    # gnome-shell-extensions
    # adwaita-icon-theme
    # nixos-background-info
    gnome-backgrounds
    # gnome-bluetooth
    # gnome-color-manager
    # gnome-control-center
    # gnome-shell-extensions
    gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    gnome-user-docs
    # glib # for gsettings program
    # gnome-menus
    # gtk3.out # for gtk-launch program
    # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    # xdg-user-dirs-gtk # Used to create the default bookmarks
    baobab
    epiphany
    gnome-text-editor
    gnome-calculator
    gnome-calendar
    gnome-characters
    # gnome-clocks
    gnome-console
    # gnome-tweaks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    # gnome-system-monitor
    gnome-weather
    # loupe
    # nautilus
    gnome-connections
    simple-scan
    snapshot
    totem
    yelp
    gnome-software
  ];

  services.xserver = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;

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
