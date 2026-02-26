{ pkgs, ... }:
{
  # User Configuration
  users = {
    users = {
      juniorsundar = (import ../users/common-system.nix) { inherit pkgs; };
    };
  };

  # Boot settings
  boot.binfmt = {
    emulatedSystems = [
      "aarch64-linux"
      "armv7l-linux"
      "riscv64-linux"
      "s390x-linux"
    ];
    preferStaticEmulators = true;
    registrations."aarch64-linux".fixBinary = true;
  };

  # Services
  services = {
    blueman.enable = true;

    syncthing =
      let
        user = "juniorsundar";
      in
      {
        enable = true;
        dataDir = "/home/${user}/Dropbox/";
        openDefaultPorts = true;
        configDir = "/home/${user}/.config/syncthing";
        inherit user;
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
      gnumake
      cmake
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
      tree-sitter
      vscode
    ];
  };
}
