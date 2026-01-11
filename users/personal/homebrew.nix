{
  ...
}:
{
  homebrew = {
    enable = true;
    user = "juniorsundar";
    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };
    casks = [
      "raspberry-pi-imager"
      "discord"
      "spotify"
      "docker"
      "zed"
    ];
    brews = [
      "gemini-cli"
    ];
  };
}
