{
  pkgs,
  config,
  lib,
  ...
}:
let
  nvidiaEnabled = lib.elem "nvidia" config.services.xserver.videoDrivers;
in
{
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
}
