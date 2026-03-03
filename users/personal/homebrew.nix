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
      "ghostty"
      "visual-studio-code"
    ];
    brews = [
      "gemini-cli"
    ];
  };
}
