{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
