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

      emacs-mirror-overlay = final: prev: {
        emacs-git = prev.emacs-git.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "emacs-mirror";
            repo = "emacs";
            rev = "54ae1944e95c77be6492d69792413e507c2dfdb0";
            hash = "sha256-wX7bTEfbjbklB2+0CjFULvTwE/WXMuS/4VejORloFZo=";
          };
        });
      };

      gemini-overlay = final: prev: {
        gemini-cli = prev.buildNpmPackage rec {
          pname = "gemini-cli";
          version = "0.22.2";

          src = prev.fetchFromGitHub {
            owner = "google-gemini";
            repo = "gemini-cli";
            rev = "v${version}";
            hash = "sha256-wVIGMkft/hamsuyJH+Ku8vIAZ2ITMfH9LqmtUIP8xN0=";
          };

          npmDepsHash = "sha256-gyv2yVTNPuwEiWDXfYr21wc+Sii5ac8nRE/04KkPmJg=";
          nativeBuildInputs = [ prev.pkg-config ];
          buildInputs = [ prev.libsecret ];
          postInstall = ''
            cp -r packages $out/lib/node_modules/@google/gemini-cli/
          '';

          makeCacheWritable = true;
        };
      };
    in
    {
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
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ emacs-overlay.overlays.default ];
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
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  gemini-overlay
                  emacs-overlay.overlays.default
                  emacs-mirror-overlay
                ];
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
