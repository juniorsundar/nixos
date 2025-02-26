{ config, pkgs, ... }:

{
  environment = {
    pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 
    variables.EDITOR = "nvim";
  };
}
