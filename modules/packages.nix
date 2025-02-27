{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Important stuff
    wget clang gcc luarocks python3 go
    psmisc unzip 

    # Functional
    zsh stow ripgrep git du-dust fd
    bat eza zoxide lazygit tmux neovim
    kitty pulsemixer

    # App Suites
    libreoffice

    # Wayland
    wofi dolphin wl-clipboard waybar
    playerctl swaylock wlogout pavucontrol
  ];
}
