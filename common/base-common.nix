{ pkgs, ... }:
{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
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
    jujutsu
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
    # gum
    neovim
    starship
    # wezterm
    kitty
    # ghostty
    nixd
    nixfmt
    nh
    gh
    opencode
  ];

  programs = {
    zsh = {
      enable = true;
    };
    bash = {
      enable = true;
      completion.enable = true;
    };
  };
}
