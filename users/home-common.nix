{ config, pkgs, inputs, ... }: {
  home.username = "juniorsundar"; # Replace with your actual username
  home.homeDirectory =
    "/home/juniorsundar"; # Adjust for macOS (/Users/username)
  home.stateVersion = "25.11";

  # Install packages
  home.packages = with pkgs; [ inkscape-with-extensions emacs-lsp-booster ];

  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs-git;
      extraPackages = epkgs: [
        epkgs.treesit-grammars.with-all-grammars
        epkgs.vterm
      ];
    };
    home-manager = { enable = true; };
  };

  services.emacs.enable = true;
}
