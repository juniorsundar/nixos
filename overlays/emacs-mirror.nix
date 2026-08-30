final: prev:
let
  emacsSrc = prev.fetchFromGitHub {
    owner = "emacs-mirror";
    repo = "emacs";
    rev = "a360712c9d272d950d8d8255ef74570f7e90b7d9";
    hash = "sha256-lFT5Vt49G17t/fRm5yppO5p9ui10I9JNJVaGO1GPZFI=";
  };
in {
  emacs-git = prev.emacs-git.overrideAttrs (old: {
    src = emacsSrc;
    # Drop upstream overlay patches already merged in our pinned source.
    patches = [];
  });
  emacs-git-pgtk = prev.emacs-git-pgtk.overrideAttrs (old: {
    src = emacsSrc;
    patches = [];
  });
}
