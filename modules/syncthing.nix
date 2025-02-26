{ config, pkgs, ... }:

{
    services.syncthing = {
        enable = true;
        group = "mygroupname";
        user = "juniorsundar";
        dataDir = "/home/juniorsundar/Dropbox";    # Default folder for new synced folders
            configDir = "/home/juniorsundar/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
};
