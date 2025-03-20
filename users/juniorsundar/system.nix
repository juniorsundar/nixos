{
    isNormalUser = true;
    description = "Junior Sundar";
    extraGroups = ["networkmanager" "wheel" "audio" "docker"];
    packages = with pkgs; [
#  thunderbird
    ];
    shell = pkgs.zsh;
};
