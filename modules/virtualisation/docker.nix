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
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings.features.cdi = lib.mkIf nvidiaEnabled true;
      };
      extraPackages = [
        pkgs.docker-buildx
        pkgs.docker-compose
      ];
    };

    hardware.nvidia-container-toolkit.enable = lib.mkIf nvidiaEnabled true;

    users.users.${cfg.allowedUser}.extraGroups = [ "docker" ];
  };
}
