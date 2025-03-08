{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:juniorsundar/dotfiles?ref=main";  # Your submodule
      flake = false;  # Important for raw files
    };

    hyprland.url = "github:hyprwm/Hyprland?ref=v0.47.0";
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.47.0"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {
    self,
    nix-flatpak,
    nixpkgs,
    home-manager,
    hyprland,
    dotfiles,
    hy3,
    ...
  } @ inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.juniorsundar = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nix-flatpak.nixosModules.nix-flatpak
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;}; # Pass inputs here
          home-manager.users.juniorsundar = import ./home-desktop.nix;
        }
      ];
    };
  };
}
