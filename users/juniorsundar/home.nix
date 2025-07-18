{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "juniorsundar"; # Replace with your actual username
  home.homeDirectory = "/home/juniorsundar"; # Adjust for macOS (/Users/username)
  home.stateVersion = "25.11";

  # Install packages
  home.packages = with pkgs; [
    wl-clipboard
    playerctl
    pavucontrol

    inkscape-with-extensions
  ];

  programs = {
    git = {
      enable = true;
      userName = "juniorsundar";
      userEmail = "juniorsundar@gmail.com";
    };
    emacs = {
      enable = true;
      package = pkgs.emacs-unstable;
      extraPackages = epkgs: [
        epkgs.treesit-grammars.with-all-grammars
      ];
    };
    home-manager = {
      enable = true;
    };
  };
}
