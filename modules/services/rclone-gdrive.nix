{ config, pkgs, ... }:
{
  programs.fuse.userAllowOther = true;

  environment.systemPackages = [
    pkgs.fuse
    pkgs.rclone
  ];

  systemd.user.services.rclone-gdrive = {
    description = "Mount Google Drive (Dropbox folder) via Rclone";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "notify";

      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Dropbox";
      Environment = "PATH=/run/wrappers/bin:$PATH";
      ExecStart = "${pkgs.rclone}/bin/rclone mount gdrive:Dropbox %h/Dropbox \\
          --config=%h/.config/rclone/rclone.conf \\
          --vfs-cache-mode full \\
          --vfs-cache-max-age 48h \\
          --vfs-read-chunk-size 32M \\
          --dir-cache-time 1000h \\
          --poll-interval 10s \\
          --allow-non-empty \\
          --no-modtime \\
          --stats=0";

      ExecStop = "/run/wrappers/bin/fusermount -u %h/Dropbox";

      Restart = "on-failure";
      RestartSec = "10s";
    };

    wantedBy = [ "default.target" ];
  };
}
