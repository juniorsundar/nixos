{ config, pkgs, inputs, lib, ... }: {
  imports = [
     ../home-common.nix
  ];

  programs = {
    git = {
      enable = true;
      userName = "juniorsundar-tii";
      userEmail = "junior.sundar@tii.ae";
    };
  };
}
