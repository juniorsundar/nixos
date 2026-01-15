{ pkgs, ... }:
{
  imports = [];

  home.username = "juniorsundar";
  home.homeDirectory = pkgs.lib.mkForce "/Users/juniorsundar";
  home.stateVersion = "25.11";

  # Install packages
  home.packages = with pkgs; [
    coreutils
    bash-completion
  ];
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
}
