{ inputs, ... }:
{
  nix-homebrew = {
    enable = true;
    user = "juniorsundar";
    enableRosetta = true;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
    autoMigrate = true;
  };
}
