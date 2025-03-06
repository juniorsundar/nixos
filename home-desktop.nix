{
  config,
  pkgs,
  ...
}: {
  home.username = "juniorsundar"; # Replace with your actual username
  home.homeDirectory = "/home/juniorsundar"; # Adjust for macOS (/Users/username)
  home.stateVersion = "24.11";

  # Install packages
  home.packages = with pkgs; [
    git
  ];


  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/zsh/.zshrc";
  };

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/nvim/.config/nvim";
    "doom".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/emacs/.config/doom";
    "wofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/wofi/.config/wofi";
    "hypr".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/hypr/.config/hypr";
    "swaync".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/swaync/.config/swaync";
  };

  xdg.dataFile = {
    
  };

  # Configure programs
  # programs.zsh.enable = true;
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
