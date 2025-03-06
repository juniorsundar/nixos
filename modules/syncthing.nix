{
  config,
  pkgs,
  ...
}: {
  services.syncthing = {
    enable = true;
    dataDir = "/home/juniorsundar/Dropbox/";
    openDefaultPorts = true;
    configDir = "/home/juniorsundar/Dropbox/.config";
    user = "juniorsundar";
    group = "users";
    guiAddress = "0.0.0.0:8384";
    # declarative = { SNIPPED };
  };
}
