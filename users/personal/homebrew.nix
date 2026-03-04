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
      "discord"
      "spotify"
      "docker-desktop"
      "zed"
      "emacs-plus-app"
      "kitty"
      "visual-studio-code"
    ];
    brews = [
      "gemini-cli"
    ];
  };
}
