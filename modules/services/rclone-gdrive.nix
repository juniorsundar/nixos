{ config, pkgs, ... }:
{
  programs.fuse.userAllowOther = true;

  environment.systemPackages = [
    pkgs.libnotify
    pkgs.rclone
    pkgs.fuse
  ];

  systemd.user.services.rclone-gdrive = {
    description = "Mount Google Drive";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "notify";
      Environment = "PATH=/run/wrappers/bin:$PATH";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/Dropbox";

      # THE SYNC COMMAND
      ExecStart = "${pkgs.rclone}/bin/rclone mount gdrive:Dropbox %h/Dropbox \\
        --config=%h/.config/rclone/rclone.conf \\
        --vfs-cache-mode full \\
        --vfs-cache-max-size 10G \\
        --vfs-cache-max-age 24h \\
        --vfs-write-back 5s \\
        --vfs-fast-fingerprint \\
        --dir-cache-time 5000h \\
        --buffer-size 0M \\
        --attr-timeout 5000h \\
        --log-level INFO";

      ExecStop = "/run/wrappers/bin/fusermount -u %h/Dropbox";
      Restart = "always";
      RestartSec = "10s";
    };
  };
}
