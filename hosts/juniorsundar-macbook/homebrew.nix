{ inputs, ... }:
{
  nix-homebrew = {
    enable = true;
    user = "juniorsundar";
    enableRosetta = true;

    taps = {
      "d12frosted/homebrew-emacs-plus" = inputs.homebrew-emacs-plus;
    };

    mutableTaps = true;
    autoMigrate = true;
  };
}
