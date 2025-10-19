{ config, pkgs, inputs, lib, ... }: {
    imports = [
        ../home-common.nix
    ];

    programs = {
        git = {
            enable = true;
            settings = {
                user = {
                    name = "juniorsundar-tii";
                    email = "junior.sundar@tii.ae";
                };
            };
        };
    };
}
