final: prev:
let
  emacsSrc = prev.fetchFromGitHub {
    owner = "emacs-mirror";
    repo = "emacs";
    rev = "672379785683d434415cbf0fb81417fe219f0593";
    hash = "sha256-748pFQvix6XbW4VxPKztGj6fNcony2ZxOBvmk3a7c6Y=";
  };
in {
  emacs-git = prev.emacs-git.overrideAttrs (old: {
    src = emacsSrc;
    # Keep all patches except Tramp ones that are already merged in our pinned source.
    patches = builtins.filter
      (p: !(builtins.match ".*tramp.*" (p.name or (baseNameOf (toString p))) != null))
      (old.patches or []);
  });
  emacs-git-pgtk = prev.emacs-git-pgtk.overrideAttrs (old: {
    src = emacsSrc;
    # Keep all patches except Tramp ones that are already merged in our pinned source.
    patches = builtins.filter
      (p: !(builtins.match ".*tramp.*" (p.name or (baseNameOf (toString p))) != null))
      (old.patches or []);
  });
}
