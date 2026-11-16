{
  pkgs,
  ...
}:
{
  imports = [ ../modules/emacs.nix ];

  home.username = "juniorsundar";
  home.homeDirectory = "/home/juniorsundar";
  home.stateVersion = "25.11";
  home.backupFileExtension = "backup";

  targets.genericLinux = {
    enable = true;
    gpu.nvidia = {
      # Version must match Ubuntu's driver exactly (nvidia-smi).
      enable = true;
      version = "595.99.02";
      sha256 = "sha256-6HR3lYv3YwcFSTJL1a1slI66btIQ5EAFs+/4SUD24ew=";
    };
  };

  home.packages = import ../../common/cli-packages.nix pkgs;

  # HM owns ~/.zshrc (so direnv etc. can hook in); the real config stays in dotfiles.
  programs.zsh = {
    enable = true;
    enableCompletion = false; # dotfiles .zshrc runs compinit itself
    envExtra = ''[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"'';
    initContent = ''[ -r "$HOME/dotfiles/zsh/.zshrc" ] && source "$HOME/dotfiles/zsh/.zshrc"'';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
