{
  config,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  services.printing.enable = true;
  services.tailscale.enable = true;
  services.openssh.enable = true;
  nixpkgs.config.allowUnfree = true;
  virtualisation.docker.enable = true;

  time.timeZone = "Asia/Dubai";
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

  environment = {
    pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw
    variables.EDITOR = "nvim";
    variables.MANPAGER = "nvim +Man!";
  };

  services.flatpak = {
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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  environment.systemPackages = with pkgs; [

    # Functional
    unzip
    wget
    imagemagick
    luarocks
    zsh
    stow
    btop
    ripgrep
    git
    delta
    du-dust
    fd
    bat
    eza
    zoxide
    lazygit
    zellij
    neovim
    ghostty
    pulsemixer
    wezterm
    networkmanagerapplet
  ];

  programs = {
    firefox.enable = true;
    nix-ld.enable = true;
    zsh.enable = true;
    thunar.enable = true;
  };


  system.stateVersion = "24.11"; # Did you read the comment?
}
