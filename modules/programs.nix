{ config, pkgs, ... }:

{
  programs = {
    firefox.enable = true;
    nix-ld.enable = true;
    zsh.enable = true;
    thunar.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
