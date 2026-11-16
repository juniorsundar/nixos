{
  pkgs,
  inputs,
  options,
  ...
}:
let
  pi = inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # Works as both a NixOS and a home-manager module.
  # Keys under `config` are chosen lazily to avoid infinite recursion on `options`.
  config =
    if options ? home then
      { home.packages = [ pi ]; }
    else
      { environment.systemPackages = [ pi ]; };
}
