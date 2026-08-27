final: prev: {
  emacs-git = prev.emacs-git.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "a360712c9d272d950d8d8255ef74570f7e90b7d9";
      hash = "sha256-lFT5Vt49G17t/fRm5yppO5p9ui10I9JNJVaGO1GPZFI=";
    };
  });
}
