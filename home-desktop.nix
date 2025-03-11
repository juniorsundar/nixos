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

    devcontainer
    docker
    docker-compose
  ];

  home.file = {
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/git/.gitconfig";
    ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.p10k.zsh";
    ".themes".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/gtk/.themes";
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/wezterm/.wezterm.lua";
    ".zoxide.zsh".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zoxide.zsh";
    ".zsh_aliases".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zsh_aliases";
    ".zsh_completions".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zsh_completions";
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zshrc";
  };

  xdg = {
    configFile = {
      "bat".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/bat/.config/bat";
      "btop".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/btop/.config/btop";
      "delta".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/delta/.config/delta";
      "doom".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/emacs/.config/doom";
      "gtk-2.0".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/gtk/.config/gtk-2.0";
      "gtk-3.0".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/gtk/.config/gtk-3.0";
      "gtk-4.0".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/gtk/.config/gtk-4.0";
      "kitty".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/kitty/.config/kitty";
      "lazygit".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/lazygit/.config/lazygit";
      "nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/nvim/.config/nvim";
      "rofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/rofi/.config/rofi";
      "swaync".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/swaync/.config/swaync";
      "waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/waybar/.config/waybar";
      "wofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/wofi/.config/wofi";
      "zellij".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zellij/.config/zellij";
      "zsh-abbr".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.config/zsh-abbr";
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
