{ config, pkgs, ... }: {
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
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

  services = { openssh.enable = true; };

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
    # zellij
    tmux
    gum
    neovim
    starship
    wezterm
    # kitty
    nixd
  ];

  programs = { zsh.enable = true; };
}
