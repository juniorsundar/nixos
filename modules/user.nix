{ config, pkgs, ... }:

{
  users.users.juniorsundar = {
    isNormalUser = true;
    description = "Junior Sundar";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };
}
