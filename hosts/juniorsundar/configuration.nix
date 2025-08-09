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

  users = {
    users = {
      juniorsundar = (import ../../users/juniorsundar/system.nix) {
        inherit pkgs;
      };
    };
    extraGroups.docker.members = ["juniorsundar"];
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  #===== SERVICES
  services = {
    blueman.enable = true;

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
      xkb = {
        layout = "us";
        variant = "";
      };

      videoDrivers = ["nvidia"];
    };

  };

  environment = {
    shells = with pkgs; [zsh bash];
    #===== Host Packages
    systemPackages = with pkgs; [
      # Important stuff
      clang
      gcc
      go
      psmisc
      python3
      glibc
      zig
      # fileSystems
      ntfs3g
      mosh
      # App Suites
      libreoffice
      vscode
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}
