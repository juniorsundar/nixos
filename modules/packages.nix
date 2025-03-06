{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # fileSystems
    ntfs3g

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
    ripgrep
    git
    du-dust
    fd
    bat
    eza
    zoxide
    lazygit
    zellij #tmux
    neovim
    emacs30
    kitty
    pulsemixer
    wezterm

    # App Suites
    libreoffice

    # Wayland
    wl-clipboard
    waybar
    wofi
    swaynotificationcenter
    playerctl
    swaylock
    wlogout
    pavucontrol
  ];

  programs = {
    # firefox.enable = true;
    nix-ld.enable = true;
    zsh.enable = true;
    thunar.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
