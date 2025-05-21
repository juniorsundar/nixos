{
  config,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Dubai";

  environment = {
    pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw
    variables.EDITOR = "nvim";
    variables.MANPAGER = "nvim +Man!";
  };

  services = {
    tailscale.enable = true;
    openssh.enable = true;
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
    starship
    wezterm
  ];

  programs = {
    zsh.enable = true;
  };
}
