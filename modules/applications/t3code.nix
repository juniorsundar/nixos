{
  pkgs,
  inputs,
  options,
  ...
}:
let
  t3code = inputs.t3code.packages.${pkgs.stdenv.hostPlatform.system};
  packages = [
    t3code.t3code
    t3code.t3code-desktop
  ];
in
{
  # Works as both a NixOS and a home-manager module.
  # Keys under `config` are chosen lazily to avoid infinite recursion on `options`.
  config =
    if options ? home then
      { home.packages = packages; }
    else
      { environment.systemPackages = packages; };
}
