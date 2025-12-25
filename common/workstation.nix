{ config, pkgs, ... }:
{
  # User Configuration
  users = {
    users = {
      juniorsundar = (import ../users/common-system.nix) { inherit pkgs; };
    };
    extraGroups.docker.members = [ "juniorsundar" ];
  };

  # Boot settings
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Services
  services = {
    blueman.enable = true;

    syncthing = {
      enable = true;
      dataDir = "/home/juniorsundar/Dropbox/";
      openDefaultPorts = true;
      configDir = "/home/juniorsundar/.config/syncthing";
      user = "juniorsundar";
      group = "users";
      guiAddress = "0.0.0.0:8384";
    };

    libinput.enable = true;
    xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  # Environment
  environment = {
    shells = with pkgs; [
      zsh
      bash
    ];
    
    systemPackages = with pkgs; [
      # Important stuff
      clang
      gcc
      psmisc
      python3
      glibc
      nodejs
      uv
      direnv
      # fileSystems
      ntfs3g
      mosh
      # App Suites
      libreoffice
      vscode
      tree-sitter
    ];
  };
}
