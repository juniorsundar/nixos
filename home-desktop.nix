{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "juniorsundar"; # Replace with your actual username
  home.homeDirectory = "/home/juniorsundar"; # Adjust for macOS (/Users/username)
  home.stateVersion = "24.11";

  # Install packages
  home.packages = with pkgs; [
    # fileSystems
    ntfs3g

    wl-clipboard

    grim
    mosh
    waybar
    wofi
    mako
    playerctl
    swaylock
    wlogout
    pavucontrol
    rofi-wayland
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    extraConfig = import (inputs.dotfiles + "/hypr/.config/hypr/hypr-home-desktop.nix") {
      inherit inputs pkgs;
    };
    plugins = [inputs.hy3.packages.x86_64-linux.hy3];
  };

  programs.git = {
    enable = true;
    userName = "juniorsundar";
    userEmail = "juniorsundar@gmail.com";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-unstable;
    extraPackages = (epkgs: [
      epkgs.treesit-grammars.with-all-grammars
    ]);
  };

  # Enable Home Manager
  programs.home-manager = {
    enable = true;
  };
}
