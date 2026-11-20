{ pkgs, dotfiles, ... }:
{
  imports = [
    ./modules/emacs.nix
  ];

  home.username = "juniorsundar";
  home.homeDirectory = "/home/juniorsundar";
  home.stateVersion = "25.11";

  home.file = {
    ".config/bat".source = "${dotfiles}/bat/.config/bat";
    ".config/btop".source = "${dotfiles}/btop/.config/btop";
    ".config/delta".source = "${dotfiles}/delta/.config/delta";
    ".config/lazygit".source = "${dotfiles}/lazygit/.config/lazygit";
    ".config/starship.toml".source = "${dotfiles}/starship/.config/starship.toml";

    ".bashrc".source = "${dotfiles}/bash/.bashrc";
    ".bash_aliases".source = "${dotfiles}/bash/.bash_aliases";
    ".fzf-git.sh".source = "${dotfiles}/zsh/.fzf-git.sh";
  };

  # The nix CLI lives in the installer's default profile, which Ubuntu's
  # /etc/profile.d/nix.sh only adds for bash login shells.
  home.sessionPath = [ "/nix/var/nix/profiles/default/bin" ];

  # Install packages
  home.packages = with pkgs; [
    inkscape-with-extensions
  ];

  programs.home-manager.enable = true;
}
