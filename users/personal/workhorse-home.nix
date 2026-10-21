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

  programs.home-manager.enable = true;
}
