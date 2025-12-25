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

  # Install packages
  home.packages = with pkgs; [
    inkscape-with-extensions
  ];

  programs.home-manager.enable = true;
}
