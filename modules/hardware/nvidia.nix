{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];
  hardware = {
    nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
