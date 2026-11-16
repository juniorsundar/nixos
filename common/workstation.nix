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

  # Programs
  programs.direnv = {
    enable = true;
    # Caches each project's evaluated devShell, so re-entering a directory does
    # not re-realise the shell derivation. Without this, direnv's own `use
    # flake` runs `nix print-dev-env` on every load, which rebuilds whenever the
    # derivation changed — for flakes that embed their source, that is every
    # edit.
    nix-direnv.enable = true;
  };

  # Environment
  environment = {
    shells = with pkgs; [
      zsh
      bash
    ];

    systemPackages = with pkgs; [
      # fileSystems
      ntfs3g
    ];
  };
}
