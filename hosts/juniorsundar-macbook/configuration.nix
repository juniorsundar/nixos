{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    tree-sitter
    direnv
  ];
}
