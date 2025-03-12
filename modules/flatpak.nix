{
  config,
  pkgs,
  ...
}: {
  services.flatpak = {
    enable = true;
    packages = [
      {
        appId = "com.stremio.Stremio";
        origin = "flathub";
      }
      {
        appId = "md.obsidian.Obsidian";
        origin = "flathub";
      }
    ];
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
}
