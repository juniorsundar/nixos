{
  config,
  pkgs,
  ...
}: {
  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  fileSystems."/mnt/drive_01" = {
    device = "/dev/disk/by-uuid/22d7d5c8-a400-4657-8d37-f0ad61531f5c";
    fsType = "ext4";
    options = ["defaults" "noauto" "x-systemd.automount" "nofail"];
  };

  fileSystems."/mnt/drive_02" = {
    device = "/dev/disk/by-uuid/C4E46B98E46B8B8C";
    fsType = "ntfs-3g";
    options = ["defaults" "noauto" "x-systemd.automount" "nofail"];
  };

  fileSystems."/mnt/drive_03" = {
    device = "/dev/disk/by-uuid/9CE87958E879319E";
    fsType = "ntfs-3g";
    options = ["defaults" "noauto" "x-systemd.automount" "nofail"];
  };

  networking = {
    networkmanager.enable = true;
    hostName = "juniorsundar";
    # wireless.enable = true;
  };

  users.users.juniorsundar = {
    isNormalUser = true;
    description = "Junior Sundar";
    extraGroups = ["networkmanager" "wheel" "audio"];
    packages = with pkgs; [
      #  thunderbird
    ];
    shell = pkgs.zsh;
  };
}
