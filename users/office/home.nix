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
    ".gitconfig".source = "${dotfiles}/git/.gitconfig-office";
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