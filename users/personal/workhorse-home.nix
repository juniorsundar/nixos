{
  lib,
  pkgs,
  ...
}:
let
  searxSettings = (pkgs.formats.yaml { }).generate "searxng-settings.yml" {
    use_default_settings = true;
    search.formats = [
      "html"
      "json"
    ];
    server = {
      bind_address = "127.0.0.1";
      port = 5340;
      secret_key = "some-random-secret";
    };
  };
in
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

  # The nix CLI lives in the installer's default profile; Ubuntu's
  # /etc/profile.d/nix.sh only adds it for bash login shells, not zsh.
  home.sessionPath = [ "/nix/var/nix/profiles/default/bin" ];

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

  systemd.user.services.searx = {
    Unit = {
      Description = "SearXNG meta search engine";
      After = [ "network-online.target" ];
    };
    Service = {
      Environment = [ "SEARXNG_SETTINGS_PATH=${searxSettings}" ];
      ExecStart = lib.getExe pkgs.searxng;
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };

  programs.home-manager.enable = true;
}
