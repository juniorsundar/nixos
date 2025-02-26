{ config, pkgs, ... }:

{
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/22d7d5c8-a400-4657-8d37-f0ad61531f5c";
    fsType = "ext4";
    options = [ "defaults" "noauto" "x-systemd.automount" "nofail" ];
  };
}
