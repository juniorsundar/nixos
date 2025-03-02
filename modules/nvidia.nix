{
  config,
  pkgs,
  ...
}: {
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidia_x11;
  };
}
