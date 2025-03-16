{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Important stuff
    wget
    clang
    gcc
    luarocks
    python3
    go
    psmisc
    unzip

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
    emacs30
    kitty
    pulsemixer
    wezterm

    # App Suites
    libreoffice
    opera
  ];

  virtualisation.docker.enable = true;
  users.users.juniorsundar.extraGroups = ["docker"];
  users.extraGroups.docker.members = ["username-with-access-to-socket"];

  programs = {
    nix-ld.enable = true;
    zsh.enable = true;
    thunar.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };
}
