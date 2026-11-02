{ ... }:
{
  services.udev.extraRules = ''
    # MCU-Link (CMSIS-DAP) 1fc9:0143 and its DFU/ISP mode 1fc9:0021
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0143", MODE="0660", GROUP="dialout"
    KERNEL=="hidraw*", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0143", MODE="0660", GROUP="dialout"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0021", MODE="0660", GROUP="dialout"
    KERNEL=="hidraw*", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0021", MODE="0660", GROUP="dialout"
  '';
}
