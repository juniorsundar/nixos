{
  config,
  pkgs,
  ...
}: {
  networking = {
    networkmanager.enable = true;
    hostName = "juniorsundar";
    # wireless.enable = true;
  };

  users.users = {
    juniorsundar = import ../../users/juniorsundar/system.nix;
    extraGroups.docker.members = ["juniorsundar"];
  };

  #===== SERVICES
  services = {
    syncthing = {
      enable = true;
      dataDir = "/home/juniorsundar/Dropbox/";
      openDefaultPorts = true;
      configDir = "/home/juniorsundar/Dropbox/.config";
      user = "juniorsundar";
      group = "users";
      guiAddress = "0.0.0.0:8384";
      # declarative = { SNIPPED };
    };

    libinput.enable = true;
    xserver = {
      displayManager.gdm = {
        enable = true;
      };

      enable = true;

      xkb = {
        layout = "us";
        variant = "";
      };

      videoDrivers = ["nvidia"];
      desktopManager.xterm.enable = false;
    };
  };

  #===== Host Packages
  environment.systemPackages = with pkgs; [
    # Important stuff
    clang
    gcc
    go
    psmisc
    python3
    glibc

    # fileSystems
    ntfs3g
    mosh

    # App Suites
    libreoffice
  ];

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
