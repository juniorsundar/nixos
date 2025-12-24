{ config, pkgs, ... }:
{
  imports = [ ./hardware-autogen.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware = {
       nvidia = {
         open = false;
    # prime = {
    #   offload = {
    #     enable = true;
    #     enableOffloadCmd = true;
    #   };
    #   amdgpuBusId = "PCI:6:0:0";
    #   nvidiaBusId = "PCI:1:0:0";
    # };
         modesetting.enable = true;
         powerManagement = {
           enable = true;
           finegrained = false;
         };
         nvidiaSettings = true;
         package = config.boot.kernelPackages.nvidiaPackages.stable;
       };

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

       nvidia-container-toolkit.enable = false;
  };
}
