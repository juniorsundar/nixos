{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs = {
    niri.enable = true;
    dms-shell.enable = true;
    dsearch.enable = true;
  };

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri"; # Or "hyprland" or "sway"
  };

  # DMS pulls in gcr-ssh-agent which conflicts with programs.ssh.startAgent
  programs.ssh.startAgent = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    xwayland-satellite
    kdePackages.qt6ct

    xhost
  ];
}
