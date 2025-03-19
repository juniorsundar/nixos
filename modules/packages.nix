{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Important stuff
    clang
    gcc
    go
    imagemagick
    luarocks
    psmisc
    python3
    unzip
    wget

    # Functional
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
    # tmux
    neovim
    # kitty
    ghostty
    pulsemixer
    wezterm

    # App Suites
    libreoffice
    firefox
  ];

  virtualisation.docker.enable = true;
  users.users.juniorsundar.extraGroups = ["docker"];
  users.extraGroups.docker.members = ["username-with-access-to-socket"];

  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
    thunar.enable = true;

    # hyprland = {
    #   enable = true;
    #   xwayland.enable = true;
    # };
  };
}
