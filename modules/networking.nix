{ config, pkgs, ... }:

{
  networking = {
      networkmanager.enable = true;
      hostName = "juniorsundar";
      # wireless.enable = true;
  };
}
