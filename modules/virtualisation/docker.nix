{
  pkgs,
  config,
  lib,
  ...
}:
let
  nvidiaEnabled = lib.elem "nvidia" config.services.xserver.videoDrivers;
  cfg = config.virtualisation.docker;
in
{
  options.virtualisation.docker = {
    allowedUser = lib.mkOption {
      type = lib.types.str;
      default = "juniorsundar";
      description = "User to add to the docker group.";
    };
  };

  config = {
    boot.kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 80;
      "net.ipv4.ip_forward" = 1;
    };

    virtualisation.docker = {
      enable = true;
      rootless.enable = false;

      daemon.settings = {
        "dns" = [
          "8.8.8.8"
          "1.1.1.1"
        ];
      };

      extraPackages = [
        pkgs.docker-buildx
        pkgs.docker-compose
      ];
    };

    hardware.nvidia-container-toolkit.enable = lib.mkIf nvidiaEnabled true;

    users.groups.docker = { };

    users.users.${cfg.allowedUser} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
    };
  };
}
