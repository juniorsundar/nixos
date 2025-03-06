{
  config,
  pkgs,
  ...
}: let
  stowDirs = [
    kitty
    nvim
  ];
  dotfilesPath = "/etc/nixos/dotfiles"; # Absolute path to your dotfiles
in {
  home.username = "juniorsundar"; # Replace with your actual username
  home.homeDirectory = "/home/juniorsundar"; # Adjust for macOS (/Users/username)
  home.stateVersion = "24.11";

  # Install packages
  home.packages = with pkgs; [
    git
  ];

  home.activation.stowDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "🚀 Stowing dotfiles from ${dotfilesPath}"

    # Create backup directory with timestamp
    export STOW_BACKUP="$HOME/.stow-backup/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$STOW_BACKUP"

    ${pkgs.stow}/bin/stow \
      --verbose=3 \
      --dir="${dotfilesPath}" \
      --target="$HOME" \
      --backup="$STOW_BACKUP" \
      --adopt \
      ${toString stowDirs}

    echo "✅ Stow complete - backups stored in: $STOW_BACKUP"
  '';

  # Disable Home Manager management of stowed files
  home.file = {
    # ".config/alacritty".enable = false;
    # ".config/awesome".enable = false;
    # ".bashrc".enable = false;
    ".config/nvim" = false;
    ".config/kitty" = false;
    # Add similar entries for other managed directories/files
  };

  # Configure programs
  # programs.zsh.enable = true;
  programs.git = {
    enable = true;
    userName = "juniorsundar";
    userEmail = "juniorsundar@gmail.com";
  };

  # Enable Home Manager
  programs.home-manager = {
    enable = true;
  };
}
