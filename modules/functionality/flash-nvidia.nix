{
  config,
  lib,
  pkgs,
  ...
}:

let
  jetsonFlashPython = pkgs.python3.withPackages (
    ps: with ps; [
      pyyaml
    ]
  );
in
{
  programs.nix-ld.enable = true;
  systemd.network.links."10-jetson-l4t-usb0" = {
    matchConfig = {
      Driver = "rndis_host";
    };

    linkConfig = {
      Name = "usb0";
    };
  };
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    libusb1
    expat
    ncurses5
    glib
  ];

  services.rpcbind.enable = true;

  services.nfs.server = {
    enable = true;
    exports = ''
      /home/juniorsundar/Documents/Projects/saluki_v3_setup/orin *(rw,nohide,insecure,no_subtree_check,async,no_root_squash)
    '';
  };
  networking.firewall.enable = lib.mkForce false;
  boot.kernelModules = [
    "nfsd"
    "usbnet"
    "cdc_ether"
    "rndis_host"
  ];
  powerManagement.powertop.enable = false;

  services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0955", TEST=="power/control", ATTR{power/control}="on"
    SUBSYSTEM=="net", ACTION=="add|move", ATTRS{idVendor}=="0955", ATTRS{idProduct}=="7035", ENV{NM_UNMANAGED}="1"
  '';

  system.activationScripts.jetsonFlashCompat = ''
    mkdir -p /bin
    mkdir -p /usr/bin
    mkdir -p /usr/local/bin

    ln -sfn ${pkgs.bash}/bin/bash /bin/bash
    ln -sfn ${pkgs.libxml2.bin}/bin/xmllint /usr/bin/xmllint
    ln -sfn ${pkgs.libxml2.bin}/bin/xmllint /usr/local/bin/xmllint
  '';

  environment.systemPackages = with pkgs; [
    (lib.hiPrio jetsonFlashPython)

    (lib.hiPrio (
      writeShellScriptBin "cpp" ''
        exec ${gcc}/bin/cpp "$@"
      ''
    ))
    (writeShellScriptBin "ping6" ''
      exec ${iputils}/bin/ping -6 "$@"
    '')

    abootimg
    bash
    binutils
    bzip2
    coreutils
    cpio
    dosfstools
    dtc
    e2fsprogs
    file
    findutils
    gawk
    gcc
    gnugrep
    gnused
    gnutar
    gzip
    iproute2
    iputils
    lbzip2
    libxml2.bin
    lz4
    mtools
    nettools
    nfs-utils
    openssh
    openssl
    parted
    pciutils
    perl
    pigz
    ripgrep
    rpcbind
    rsync
    squashfsTools
    sshpass
    usbutils
    util-linux
    which
    xz
    zstd

    (writeShellScriptBin "service" ''
      set -euo pipefail

      svc="''${1:-}"
      action="''${2:-}"

      case "$svc" in
        nfs-kernel-server|nfs-server)
          unit="nfs-server.service"
          ;;
        rpcbind)
          unit="rpcbind.service"
          ;;
        udev)
          unit="systemd-udevd.service"
          ;;
        *)
          unit="''${svc}.service"
          ;;
      esac

      case "$action" in
        start|stop|restart|status|reload)
          exec systemctl "$action" "$unit"
          ;;
        force-reload)
          exec systemctl reload-or-restart "$unit"
          ;;
        *)
          echo "Unsupported service command: service $svc $action" >&2
          exit 1
          ;;
      esac
    '')

    (writeShellScriptBin "patch-l4t-for-nixos" ''
        set -euo pipefail

        L4T_DIR="''${1:-$(pwd)}"
        cd "$L4T_DIR"

        if [ ! -d tools/kernel_flash ]; then
          echo "error: tools/kernel_flash not found."
          echo "Run from Linux_for_Tegra or pass its path:"
          echo "  patch-l4t-for-nixos /path/to/Linux_for_Tegra"
          exit 1
        fi

        echo "Patching fresh NVIDIA L4T tree for NixOS host flashing:"
        echo "  $L4T_DIR"
        echo

        echo "1. Patching NVIDIA temporary udev rule path..."
        # NixOS owns udev rules declaratively, but NVIDIA's script still tries to
        # create/remove a temporary rule. Redirect that from /etc to /run so it does
        # not mutate the NixOS-managed /etc tree.
        if [ -f tools/kernel_flash/l4t_initrd_flash.sh ]; then
          sed -i \
            's|/etc/udev/rules.d/|/run/udev/rules.d/|g' \
            tools/kernel_flash/l4t_initrd_flash.sh
        fi

        mkdir -p /run/udev/rules.d 2>/dev/null || sudo mkdir -p /run/udev/rules.d

        echo "2. Patching PATH into NVIDIA initrd flash scripts..."
        # NVIDIA scripts assume Ubuntu/FHS paths. Put NixOS compatibility paths first.
        for f in \
          tools/kernel_flash/l4t_initrd_flash.sh \
          tools/kernel_flash/l4t_initrd_flash_internal.sh
        do
          if [ -f "$f" ] && ! rg -q 'NIXOS_JETSON_FLASH_PATH_PATCH' "$f"; then
            sed -i '2i\
      # NIXOS_JETSON_FLASH_PATH_PATCH\
      export PATH="/run/current-system/sw/bin:/usr/local/bin:/usr/bin:$PATH"\
      ' "$f"
          fi
        done

        echo "3. Patching /bin/bash shebangs in host-side scripts..."
        # This is optional if /bin/bash exists, but useful when executing nested scripts.
        rg -l --no-messages '^#!/bin/bash' tools bootloader \
          | xargs -r sed -i '1s|^#!/bin/bash|#!/usr/bin/env bash|'

        echo "4. Removing deprecated DSA SSH host key generation..."
        # Modern OpenSSH rejects/blocks DSA key generation in this recovery ramdisk path.
        # NVIDIA already generates RSA/ECDSA keys, so the DSA key is unnecessary.
        if [ -f tools/ota_tools/version_upgrade/ota_make_recovery_img_dtb.sh ]; then
          sed -i \
            '/ssh-keygen -t dsa .*ssh_host_dsa_key/d' \
            tools/ota_tools/version_upgrade/ota_make_recovery_img_dtb.sh
        fi

        echo
        echo "Patch summary:"
        echo

        echo "udev mutation lines remaining:"
        rg -n --no-messages '99-l4t-host.rules|10-l4t-usb-msd.rules|udev/rules.d' \
          tools/kernel_flash/l4t_initrd_flash.sh || true
        echo

        echo "PATH patches:"
        rg -n --no-messages 'NIXOS_JETSON_FLASH_PATH_PATCH' tools/kernel_flash || true
        echo

        echo "remaining /bin/bash shebangs in host-side scripts:"
        rg -n --no-messages '^#!/bin/bash' tools bootloader || true
        echo

        echo "ssh-keygen references:"
        rg -n --no-messages 'ssh-keygen|ssh_host_dsa' \
          tools/ota_tools/version_upgrade/ota_make_recovery_img_dtb.sh || true
        echo

        echo "Done."
    '')
  ];
}
