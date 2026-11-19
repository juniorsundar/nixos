pkgs:
with pkgs;
[
  # Functional
  unzip
  lsof
  wget
  imagemagick
  luarocks
  zsh
  stow
  bottom
  ripgrep
  git
  jujutsu
  delta
  dust
  fd
  bat
  eza
  zoxide
  lazygit
  ripdrag
  # zellij
  yazi
  tmux
  neovim
  starship
  kitty
  ghostty
  nixd
  nixfmt
  nh
  gh
  claude-code
  forgejo-cli
  clang
  gnumake
  cmake
  (lib.hiPrio gcc) # gcc and clang wrappers both ship cc/cpp/ld; gcc wins, clang/clang++ still available
  psmisc
  glibc
  nodejs
  uv
  python3
  jdk
  graphviz
  husky
  distrobox
  jq
  pandoc
  mosh
  libreoffice-stable
  tree-sitter
  vscodium

]
