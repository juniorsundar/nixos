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
    ".gitconfig".source = "${dotfiles}/git/.gitconfig";
  };

  imports = [ ../home-common.nix ];

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "juniorsundar";
          email = "juniorsundar@gmail.com";
        };
      };
    };
  };
}