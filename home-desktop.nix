{pkgs, ...}: {
  home.username = "juniorsundar"; # Replace with your actual username
  home.homeDirectory = "/home/juniorsundar"; # Adjust for macOS (/Users/username)
  home.stateVersion = "24.11";

  # Install packages
  home.packages = with pkgs; [
    git
    home-manager
  ];

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
