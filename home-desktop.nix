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
    wl-clipboard
    waybar
    wofi
    swaynotificationcenter
    playerctl
    swaylock
    wlogout
    pavucontrol
  ];

  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zshrc";
  };

  xdg = {
    configFile = {
      "nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/nvim/.config/nvim";
      "doom".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/emacs/.config/doom";
      "wofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/wofi/.config/wofi";
      "swaync".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/swaync/.config/swaync";
      "zellij".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zellij/.config/zellij";
    };

    dataFile = {
    };
  };

  wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      extraConfig = import (inputs.dotfiles + "/hypr/.config/hypr/hypr-home-desktop.nix") {
          inherit inputs pkgs;
      };
};

  programs.git = {
    enable = true;
    userName = "juniorsundar";
    userEmail = "juniorsundar@gmail.com";
  };

  # Enable Home Manager
  programs.home-manager = {
    enable = true;
  };
}
