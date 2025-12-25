{ config, pkgs, ... }:
{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise = {
      automatic = true;
      dates = [ "23:00" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Dubai";

  environment = {
    variables.EDITOR = "nvim";
    variables.MANPAGER = "nvim +Man!";
  };

  services = {
    openssh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Functional
    unzip
    lsof
    wget
    imagemagick
    luarocks
    zsh
    stow
    btop
    ripgrep
    git
    delta
    dust
    fd
    bat
    eza
    zoxide
    lazygit
    # zellij
    yazi
    tmux
    gum
    neovim
    starship
    # wezterm
    kitty
    nixd
    nixfmt
    nh
    gh
    gemini-cli
  ];

  programs = {
    zsh.enable = true;
  };
}
