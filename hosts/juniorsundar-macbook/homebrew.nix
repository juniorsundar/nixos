{ inputs, ... }:
{
  nix-homebrew = {
    enable = true;
    user = "juniorsundar";
    enableRosetta = true;

    mutableTaps = true;
    autoMigrate = true;
  };
}
