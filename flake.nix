{
  description = "Junior's Single Source of Truth";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      # url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures nix-darwin uses the same nixpkgs
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay?ref=6f91e22329ed0b59ac491a81032abcc4414877c5";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-emacs-plus = {
      url = "github:d12frosted/homebrew-emacs-plus";
      flake = false;
    };

    wezterm.url = "github:wezterm/wezterm?dir=nix";
  };

  outputs =
    {
      self,
      nix-flatpak,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      home-manager,
      emacs-overlay,
      ...
    }@inputs:
    let
      # Fetch dotfiles WITH submodules
      dotfiles = fetchGit {
        url = "https://github.com/juniorsundar/dotfiles";
        rev = "05bdbf0e98ca58558fdc2cb73db7276e7d76b285";
      };

      emacs-mirror-overlay = import ./overlays/emacs-mirror.nix;

      # Helper function to create a NixOS system
      mkNixosSystem =
        {
          hostname,
          users,
          system ? "x86_64-linux",
          extraOverlays ? [ ],
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Common base configuration
            ./common/base-common.nix
            ./common/linux-common.nix

            # Host-specific configuration
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware.nix

            # Overlays
            (
              { ... }:
              {
                nixpkgs.overlays = extraOverlays;
              }
            )

            # External modules
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs dotfiles;
                };
                inherit users;
              };
            }
          ]
          ++ extraModules;
        };

      # Helper function to create a nix-darwin system
      mkDarwinSystem =
        {
          hostname,
          users,
          system ? "aarch64-darwin",
          extraOverlays ? [ ],
          extraModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            flakeSelf = self;
            inherit inputs;
          };
          modules = [
            # Common base configuration
            ./common/base-common.nix
            ./common/mac-common.nix

            # Host-specific configuration
            nix-homebrew.darwinModules.nix-homebrew
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/homebrew.nix

            # Overlays
            (
              { ... }:
              {
                nixpkgs.overlays = extraOverlays;
              }
            )

            # External modules
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs dotfiles;
                };
                inherit users;
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      # Hostname
      nixosConfigurations = {
        juniorsundar = mkNixosSystem {
          hostname = "juniorsundar";
          users = {
            juniorsundar = import ./users/personal/home.nix;
          };
          extraOverlays = [
            emacs-overlay.overlays.default
            emacs-mirror-overlay
          ];
          extraModules = [
            ./modules/desktop-managers/plasma6.nix
            ./modules/sound/pipewire.nix
            ./modules/hardware/nvidia.nix
            ./modules/virtualisation/docker.nix
            ./modules/services/rclone-gdrive.nix
          ];
        };

        juniorsundar-office = mkNixosSystem {
          hostname = "juniorsundar-office";
          users = {
            juniorsundar = import ./users/office/home.nix;
          };
          extraOverlays = [
            emacs-overlay.overlays.default
            emacs-mirror-overlay
          ];
          extraModules = [
            ./modules/desktop-managers/plasma6.nix
            ./modules/sound/pipewire.nix
            ./modules/hardware/nvidia.nix
            ./modules/virtualisation/docker.nix
            ./modules/virtualisation/libvirtd.nix
          ];
        };
      };

      darwinConfigurations."juniorsundar-macbook" = mkDarwinSystem {
        hostname = "juniorsundar-macbook";
        users = {
          juniorsundar = import ./users/personal/mac-home.nix;
        };
        extraOverlays = [
          emacs-overlay.overlays.default
          emacs-mirror-overlay
        ];
        extraModules = [
          ./users/personal/homebrew.nix
        ];
      };
    };
}
