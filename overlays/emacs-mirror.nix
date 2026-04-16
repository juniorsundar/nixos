final: prev: {
  emacs-git = prev.emacs-git.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "636f166cfc86aa90d63f592fd99f3fdd9ef95ebd";
      hash = "sha256-3Lfb3HqdlXqSnwJfxe7npa4GGR9djldy8bKRpkQCdSA=";
    };
  });
}
