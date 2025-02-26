{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget clang gcc luarocks python3 go
    zsh stow ripgrep git du-dust fd
    bat eza zoxide lazygit tmux neovim
    xclip xsel kitty psmisc unzip arandr
    pulsemixer libreoffice
  ];
}
