{ config, pkgs, inputs, lib, ... }: {
  home.username = "juniorsundar-nix"; # Replace with your actual username
  home.homeDirectory =
    lib.mkForce "/home/juniorsundar-nix"; # Adjust for macOS (/Users/username)
  home.stateVersion = "25.11";

  # Install packages
  home.packages = with pkgs; [ inkscape-with-extensions ];

  programs = {
    git = {
      enable = true;
      userName = "juniorsundar-tii";
      userEmail = "junior.sundar@tii.ae";
    };
    # emacs = {
    #   enable = true;
    #   package = pkgs.emacs-unstable;
    #   extraPackages = epkgs: [
    #     epkgs.treesit-grammars.with-all-grammars
    #   ];
    # };
    home-manager = { enable = true; };
  };
}
