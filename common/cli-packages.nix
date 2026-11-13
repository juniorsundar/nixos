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
  (herdr-desktop.overrideAttrs (finalAttrs: old: {
    version = "0.1.15";
    src = old.src.override {
      tag = "v${finalAttrs.version}";
      hash = "sha256-CNktD+tQrMMN4vpzFPZkZWnwDalaTkUV0A2UiLVeO3E=";
    };
    cargoHash = "sha256-usCdairGam65XVKtb1jJpRC0tNXnoafAnMFQjPgvgqQ=";
    # 0.1.15 dropped the /bin/test call that upstream's postPatch rewrites.
    postPatch = builtins.replaceStrings
      [ "--replace-fail 'Command::new(\"/bin/test\")'" ]
      [ "--replace-quiet 'Command::new(\"/bin/test\")'" ]
      old.postPatch;
  }))
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
]
