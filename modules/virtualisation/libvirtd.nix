{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.virtualisation.libvirtd;
in
{
  options.virtualisation.libvirtd = {
    allowedUser = lib.mkOption {
      type = lib.types.str;
      default = "juniorsundar";
      description = "User to add to the libvirtd group.";
    };
  };

  config = {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      virtiofsd
    ];

    users.users.${cfg.allowedUser}.extraGroups = [ "libvirtd" ];
  };
}
