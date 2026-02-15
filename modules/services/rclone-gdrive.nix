{ config, pkgs, ... }:
{
  programs.fuse.userAllowOther = true;

  environment.systemPackages = [
    pkgs.libnotify
    pkgs.rclone
  ];

  systemd.user.services.rclone-gdrive = {
    description = "Rclone Bisync GDrive";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.config/rclone";
      ExecStart = pkgs.writeShellScript "rclone-sync-logic" ''
        ${pkgs.libnotify}/bin/notify-send -i sync-synchronizing "Rclone GDrive" "Syncing started..."

        if ${pkgs.rclone}/bin/rclone bisync \
          "gdrive:Dropbox" "$HOME/Dropbox" \
          --compare size,modtime,checksum \
          --modify-window 1s \
          --create-empty-src-dirs \
          --drive-acknowledge-abuse \
          --drive-skip-gdocs \
          --drive-skip-shortcuts \
          --drive-skip-dangling-shortcuts \
          --metadata \
          --progress \
          --verbose \
          --log-file "$HOME/.config/rclone/rclone.log" \
          --track-renames \
          --fix-case \
          --resilient \
          --recover \
          --max-lock 2m \
          --check-access; then

          ${pkgs.libnotify}/bin/notify-send -i security-high "Rclone GDrive" "Sync completed successfully."
        else
          ${pkgs.libnotify}/bin/notify-send -u critical -i dialog-error "Rclone GDrive" "Sync FAILED. Check logs."
          exit 1
        fi
      '';
    };
  };

  systemd.user.timers.rclone-bisync-gdrive = {
    description = "Run Rclone Bisync every 15 minutes";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*:0/15";
      OnStartupSec = "2m";
      Persistent = true;
      Unit = "rclone-gdrive.service";
    };
  };
}
