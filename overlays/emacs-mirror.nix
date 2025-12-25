final: prev: {
  emacs-git = prev.emacs-git.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "54ae1944e95c77be6492d69792413e507c2dfdb0";
      hash = "sha256-wX7bTEfbjbklB2+0CjFULvTwE/WXMuS/4VejORloFZo=";
    };
  });
}
