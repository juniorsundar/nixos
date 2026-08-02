{ pkgs, ... }:
{
  imports = [ ../../common/workstation.nix ];

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
        networkmanager-openvpn
      ];
    };
    hostName = "juniorsundar-laptop";
    # wireless.enable = true;
  };


}
