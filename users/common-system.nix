{ pkgs, ... }:
{
  isNormalUser = true;
  description = "Junior Sundar";
  extraGroups = [
    "networkmanager"
    "wheel"
    "audio"
    "dialout"
  ];
  shell = pkgs.zsh; # Set login shell to Zsh
}
