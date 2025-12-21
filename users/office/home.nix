{
  config,
  pkgs,
  inputs,
  dotfiles,
  lib,
  ...
}:
{
  home.file = {
    ".config/bat".source = "${dotfiles}/bat/.config/bat";
    ".config/btop".source = "${dotfiles}/btop/.config/btop";
    ".config/delta".source = "${dotfiles}/delta/.config/delta";
    ".config/lazygit".source = "${dotfiles}/lazygit/.config/lazygit";
    ".config/starship.toml".source = "${dotfiles}/starship/.config/starship.toml";

    ".bashrc".source = "${dotfiles}/bash/.bashrc";
    ".bash_aliases".source = "${dotfiles}/bash/.bash_aliases";
    ".gitconfig".source = "${dotfiles}/git/.gitconfig-office";
    ".fzf-git.sh".source = "${dotfiles}/zsh/.fzf-git.sh";
  };

  imports = [ ../home-common.nix ];

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "juniorsundar-tii";
          email = "junior.sundar@tii.ae";
        };
      };
    };
  };
}
