{ config, pkgs, ... }:
{
  programs.fuse.userAllowOther = true;

  environment.systemPackages = [
    pkgs.fuse
    pkgs.rclone
  ];

  systemd.user.services.rclone-bisync = {
    description = "Bidirectional Sync for Obsidian (Google Drive)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      Environment = "PATH=/run/wrappers/bin:$PATH";

      # THE SYNC COMMAND
      ExecStart = "${pkgs.rclone}/bin/rclone bisync gdrive:Dropbox %h/Dropbox \\
          --config=%h/.config/rclone/rclone.conf \\
          --verbose \\
          --conflict-resolve newer \\
          --remove-empty-dirs \\
          --ignore-listing-checksum \\
          --checkers=16 \\
          --resync-mode newer";
    };
  };

  # 2. The Timer (Triggers the service periodically)
  systemd.user.timers.rclone-bisync = {
    description = "Run Obsidian Sync every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
      OnUnitActiveSec = "5m";
      Unit = "rclone-bisync.service";
    };
  };
}
