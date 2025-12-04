{ config, pkgs, inputs, ... }: {
  home.username = "juniorsundar"; # Replace with your actual username
  home.homeDirectory = pkgs.lib.mkForce "/Users/juniorsundar";
  home.stateVersion = "25.11";

  # Install packages
  home.packages = with pkgs; [ 
    emacs-lsp-booster
    coreutils
  ];
  fonts.fontconfig.enable = true;

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

}
