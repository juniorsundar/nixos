{ inputs, pkgs, ... }:
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
    variables.TERMINAL = "kitty";
  };

  services = {
    openssh.enable = true;

    searx = {
      enable = true;
      package = pkgs.searxng;
      redisCreateLocally = true;
      settings = {
        search.formats = [ "html" "json" ];
        server = {
        bind_address = "127.0.0.1";
        port = 5340;
        secret_key = "some-random-secret";
      };
      };
    };
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
    ripdrag
    # zellij
    yazi
    tmux
    neovim
    starship
    # wezterm
    kitty
    # ghostty
    nixd
    nixfmt
    nh
    gh
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
