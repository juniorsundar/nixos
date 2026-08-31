{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.wezterm.packages.${pkgs.system}.default
  ];

  home-manager.users.juniorsundar = lib.mkIf pkgs.stdenv.isLinux {
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
}
