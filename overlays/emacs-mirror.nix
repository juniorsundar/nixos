final: prev: {
  emacs-git = prev.emacs-git.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "0ee48ac4df205e0d915946b5db00e73a0cd21ae0";
      hash = "sha256-Rzlnn+NKQ+jICXLNop27RnVInq79myn4hueJieDO2Ck=";
    };
  });
}
