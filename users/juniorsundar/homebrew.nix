{
  inputs,
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}: {
  homebrew = {
    enable = true;
    user = "juniorsundar";
    casks = [
      "raspberry-pi-imager"
      "discord"
      "spotify"
    ];
  };
}
