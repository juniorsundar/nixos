{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url =
      "github:gmodena/nix-flatpak/"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      # url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows =
        "nixpkgs"; # Ensures nix-darwin uses the same nixpkgs
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
      url =
        "github:nix-community/emacs-overlay?ref=9535ea88059f185b72480d7e7b0cbcdbf06b78a6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm.url = "github:wezterm/wezterm?dir=nix";
  };

  outputs = { self, nix-flatpak, nixpkgs, nix-darwin, nix-homebrew
    , homebrew-core, homebrew-cask, home-manager, dotfiles, emacs-overlay
    , wezterm, ... }@inputs:
    let
      # Fetch dotfiles WITH submodules
      dotfiles = builtins.fetchGit {
        url = "https://github.com/juniorsundar/dotfiles";
        rev = "db05496db90a7b338d6cc98f1a18aa7547adaeab";
      };
    in {
      # Hostname
      nixosConfigurations = {
        juniorsundar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Common base configuration
            ./common/base-common.nix
            ./common/linux-common.nix
            ./common/hardware.nix

            # Host-specific configuration
            ./hosts/juniorsundar/configuration.nix
            ./hosts/juniorsundar/hardware.nix

            # Display Manager
            ./modules/desktop-managers/plasma6.nix
            # Overlays
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [ emacs-overlay.overlays.default ];
            })

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
                }; # Pass inputs here
                users = {
                  juniorsundar = import ./users/personal/home.nix;
                  # anotherUser = import ./...;
                };
              };
            }
          ];
        };

        juniorsundar-office = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # Common base configuration
            ./common/base-common.nix
            ./common/linux-common.nix
            ./common/hardware.nix

            # Host-specific configuration
            ./hosts/juniorsundar-office/configuration.nix
            ./hosts/juniorsundar-office/hardware.nix

            # Display Manager
            ./modules/desktop-managers/plasma6.nix
            # Overlays
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [
                emacs-overlay.overlays.default
              ];
            })

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
                }; # Pass inputs here
                users = {
                  juniorsundar = import ./users/office/home.nix;
                  # anotherUser = import ./...;
                };
              };
            }
          ];
        };
        # anotherHost = ... {};
      };
      darwinConfigurations."juniorsundar-macbook" =
        nix-darwin.lib.darwinSystem {
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
          ];
        };
    };
}
