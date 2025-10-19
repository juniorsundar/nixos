{ config, pkgs, inputs, ... }: {
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
