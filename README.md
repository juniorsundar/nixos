# NixOS Configuration

> [!WARNING]
> 
> This is my personal NixOS Configuration. It is built to satisfy the way my mind works and how I wish the configuration of my systems should be structured.
> 
> Please feel free to fork this at your own risk. But DO NOT submit PRs/Issues.

## Introduction

Given the above warning, why am I wasting time in writing up a documentation/README, you might ask?

If you are a potential employer, this is for you!

## Structure

```txt
 .
├──  common
│   ├──  base-common.nix
│   ├──  linux-common.nix
│   ├──  mac-common.nix
│   └──  workstation.nix
├──  flake.lock
├──  flake.nix
├──  hosts
│   ├──  juniorsundar
│   ├──  juniorsundar-laptop
│   ├──  juniorsundar-macbook
│   └──  juniorsundar-office
├──  modules
│   ├──  desktop-managers
│   ├──  functionality
│   ├──  hardware
│   ├──  printers
│   ├──  services
│   ├──  sound
│   ├──  virtualisation
│   └──  work
├──  overlays
│   ├──  emacs-mirror.nix
│   ├──  gemini.nix
│   └──  kilocode.nix
├── 󰂺 README.md
└──  users
    ├──  common-system.nix
    ├──  home-common.nix
    ├──  modules
    ├──  office
    └──  personal
```

The structure of my Nix config is relatively straightforward. Common configurations are placed under `common/` with extra segregation depending on whether the system is Linux based or a Mac (I will eventually phase out the Mac specific definitions since Nix on Mac is pointless).

Configurations geared specifically towards my various hosts are under `hosts/`. Here there, the different config options used for my office or home setup are codified.

In `overlays/` I add configuration for flake overlays in case I want to make changes to packages (like pinning a specific emacs version or forcing a package to always follow the GitHub main branch).

Under `users/` I place my home-manager specific configs. I am not a big fan of home-manager for managing my `$HOME` since I am a tinkerer by heart and I keep making changes to my configs on a regular basis. Running a rebuild after every minute change is a buzz-kill.

For any additional modules that may require extensive reconfiguration of the config (such as desktop-managers, specific hardware drivers, etc.) the content will be placed inside `modules/` folder. With `mkForce` to force certain config values to satisfy the module's configuration.

All of these come together in the root `flake.nix`:

```nix
        juniorsundar-laptop = mkNixosSystem {
          hostname = "juniorsundar-laptop";
          users = {
            juniorsundar = import ./users/personal/home.nix;
          };
          extraOverlays = [
            emacs-overlay.overlays.default
            emacs-mirror-overlay
          ];
          extraModules = [
            ./modules/desktop-managers/plasma6.nix
            ./modules/hardware/fingerprint.nix
            ./modules/sound/pipewire.nix
            ./modules/virtualisation/docker.nix
          ];
        };
```

