# ./hosts/juniorsundar-macbook/configuration.nix
{ inputs, config, lib, pkgs, flakeSelf, ... }: # Receives inputs and flakeSelf from specialArgs
{
  homebrew = {
      enable = true;
      user = "juniorsundar";
  };
}

