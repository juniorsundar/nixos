{
  config,
  pkgs,
  inputs,
  ...
}:
{
  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
    };
    hostName = "juniorsundar-office";
    # wireless.enable = true;
  };

  users = {
    users = {
      juniorsundar = (import ../../users/common-system.nix) { inherit pkgs; };
    };
    extraGroups.docker.members = [ "juniorsundar" ];
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  #===== SERVICES
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
      # declarative = { SNIPPED };
    };

    libinput.enable = true;
    xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };

      videoDrivers = [ "nvidia" ];
    };

  };

  environment = {
    shells = with pkgs; [
      zsh
      bash
    ];
    #===== Host Packages
    systemPackages = with pkgs; [
      # Important stuff
      clang
      gcc
      psmisc
      python3
      glibc
      nodejs
      uv
      expect
      # fileSystems
      ntfs3g
      mosh
      # App Suites
      libreoffice
      vscode
      tree-sitter

      microsoft-edge
    ];
  };

}
