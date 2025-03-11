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
    mosh
    waybar
    wofi
    swaynotificationcenter
    playerctl
    swaylock
    wlogout
    pavucontrol
    rofi-wayland
  ];

  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zshrc";
    ".zsh_aliases".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zsh_aliases";
    ".zsh_completions".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zsh_completions";
    ".zoxide.zsh".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zoxide.zsh";
    ".themes".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/gtk/.themes";
    ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.p10k.zsh";
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/wezterm/.wezterm.lua";
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/git/.gitconfig";
  };

  xdg = {
    configFile = {
      "nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/nvim/.config/nvim";
      "doom".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/emacs/.config/doom";
      "rofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/rofi/.config/rofi";
      "wofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/wofi/.config/wofi";
      "swaync".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/swaync/.config/swaync";
      "zellij".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zellij/.config/zellij";
      "waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/waybar/.config/waybar";
      "zsh-abbr".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.config/zsh-abbr";
      "kitty".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/kitty/.config/kitty";
      "lazygit".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/lazygit/.config/lazygit";
      "gtk-2.0".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/gtk/.config/gtk-2.0";
      "gtk-3.0".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/gtk/.config/gtk-3.0";
      "gtk-4.0".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/gtk/.config/gtk-4.0";
      "bat".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/bat/.config/bat";
      "delta".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/delta/.config/delta";
    };

    dataFile = {
      "rofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/rofi/.local/share/rofi";
      "fonts".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/fonts/.local/share/fonts";
    };
  };

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

  # Enable Home Manager
  programs.home-manager = {
    enable = true;
  };
}
