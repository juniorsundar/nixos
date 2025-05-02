{pkgs, ...}: {
  isNormalUser = true;
  description = "Junior Sundar";
  extraGroups = ["networkmanager" "wheel" "audio" "docker"];
  # shell = pkgs.zsh; # Set login shell to Zsh
}
