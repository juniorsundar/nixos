{ inputs, ... }:
{
  nix-homebrew = {
    enable = true;
    user = "juniorsundar"; # Set your macOS username
    enableRosetta = true; # If you are on Apple Silicon and need Rosetta for some brews/casks

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false; # Recommended for reproducibility
  };
}
