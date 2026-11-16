{
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
let
  wezterm = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;

  desktopEntry = lib.mkIf pkgs.stdenv.isLinux {
    xdg.desktopEntries."org.wezfurlong.wezterm" = {
      name = "WezTerm";
      genericName = "Terminal Emulator";
      comment = "Wez's Terminal Emulator";
      exec = "wezterm";
      icon = "org.wezfurlong.wezterm";
      terminal = false;
      type = "Application";
      categories = [
        "System"
        "TerminalEmulator"
        "Utility"
      ];
      settings = {
        Keywords = "shell;prompt;command;commandline;cmd;";
        StartupWMClass = "org.wezfurlong.wezterm";
      };
    };
  };
in
{
  # Works as both a NixOS and a home-manager module.
  config =
    if options ? home then
      lib.mkMerge [
        { home.packages = [ wezterm ]; }
        desktopEntry
      ]
    else
      {
        environment.systemPackages = [ wezterm ];
        home-manager.users.juniorsundar = desktopEntry;
      };
}
