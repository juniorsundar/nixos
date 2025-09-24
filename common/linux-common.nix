{ config, pkgs, ... }: {
  nix = {
    settings = {
      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    };
  };
  virtualisation.docker.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services = {
    flatpak = {
      enable = true;
      packages = [
        {
          appId = "com.stremio.Stremio";
          origin = "flathub";
        }
        {
          appId = "md.obsidian.Obsidian";
          origin = "flathub";
        }
      ];
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  services = {
    printing.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pulsemixer
    networkmanagerapplet
    # calibre
  ];

  programs = {
    firefox.enable = true;
    thunderbird.enable = true;
    nix-ld.enable = true;
  };
  system.stateVersion = "25.11"; # Did you read the comment?
}
