{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [ 
    obsidian
    vscode
    tree-sitter
    direnv
  ];
}
