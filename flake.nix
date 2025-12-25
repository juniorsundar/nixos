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

    dotfiles = {
      url = "github:juniorsundar/dotfiles?ref=main"; # Your submodule
      flake = false;
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay?ref=6f91e22329ed0b59ac491a81032abcc4414877c5";
      inputs.nixpkgs.follows = "nixpkgs";
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
      homebrew-core,
      homebrew-cask,
      home-manager,
      dotfiles,
      emacs-overlay,
      wezterm,
      ...
    }@inputs:
    let
      # Fetch dotfiles WITH submodules
      dotfiles = builtins.fetchGit {
        url = "https://github.com/juniorsundar/dotfiles";
        rev = "7e5cf99e61099b99b18a210e30b5fa8a05dd6247";
      };

      emacs-mirror-overlay = import ./overlays/emacs-mirror.nix;
      gemini-overlay = import ./overlays/gemini.nix;

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
            ./common/hardware.nix

            # Host-specific configuration
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware.nix

            # Overlays
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ emacs-overlay.overlays.default ] ++ extraOverlays;
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
    in
    {
      # Hostname
      nixosConfigurations = {
        juniorsundar = mkNixosSystem {
          hostname = "juniorsundar";
          users = {
            juniorsundar = import ./users/personal/home.nix;
          };
          extraModules = [ ./modules/desktop-managers/plasma6.nix ];
        };

        juniorsundar-office = mkNixosSystem {
          hostname = "juniorsundar-office";
          users = {
            juniorsundar = import ./users/office/home.nix;
          };
          extraOverlays = [
            gemini-overlay
            emacs-mirror-overlay
          ];
          extraModules = [ ./modules/desktop-managers/plasma6.nix ];
        };
      };

      darwinConfigurations."juniorsundar-macbook" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          flakeSelf = self;
          inherit inputs;
        };

        modules = [
          ./common/base-common.nix
          ./common/mac-common.nix

          nix-homebrew.darwinModules.nix-homebrew
          ./hosts/juniorsundar-macbook/configuration.nix
          ./hosts/juniorsundar-macbook/homebrew.nix

          ./users/personal/homebrew.nix
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                emacs-overlay.overlays.default
              ];
            }
          )
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.juniorsundar = import ./users/personal/mac-home.nix;
          }
        ];
      };
    };
}
