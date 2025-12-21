{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.username = "juniorsundar"; # Replace with your actual username
  home.homeDirectory = "/home/juniorsundar"; # Adjust for macOS (/Users/username)
  home.stateVersion = "25.11";

  # Install packages
  home.packages = with pkgs; [
    inkscape-with-extensions
    emacs-lsp-booster
  ];

  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs-git;
      extraPackages = epkgs: [
        (epkgs.treesit-grammars.with-grammars (
          grammars: with grammars; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-dockerfile
            tree-sitter-go
            tree-sitter-html
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-lua
            tree-sitter-markdown
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-toml
            tree-sitter-tsx
            tree-sitter-typescript
            tree-sitter-yaml
            tree-sitter-nix
          ]
        ))
        epkgs.vterm
      ];
    };
    home-manager = {
      enable = true;
    };
  };

}
