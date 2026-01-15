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
      "docker-desktop"
      "zed"
      "emacs-plus-app"
    ];
    brews = [
      "gemini-cli"
    ];
  };
}
