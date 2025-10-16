{ config, pkgs, inputs, ... }: {
  imports = [
    ../home-common.nix
  ];

  programs = {
    git = {
      enable = true;
      userName = "juniorsundar";
      userEmail = "juniorsundar@gmail.com";
    };
  };
}
