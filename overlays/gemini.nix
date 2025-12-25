final: prev: {
  gemini-cli = prev.buildNpmPackage rec {
    pname = "gemini-cli";
    version = "0.22.2";

    src = prev.fetchFromGitHub {
      owner = "google-gemini";
      repo = "gemini-cli";
      rev = "v${version}";
      hash = "sha256-wVIGMkft/hamsuyJH+Ku8vIAZ2ITMfH9LqmtUIP8xN0=";
    };

    npmDepsHash = "sha256-gyv2yVTNPuwEiWDXfYr21wc+Sii5ac8nRE/04KkPmJg=";
    nativeBuildInputs = [ prev.pkg-config ];
    buildInputs = [ prev.libsecret ];
    postInstall = ''
      cp -r packages $out/lib/node_modules/@google/gemini-cli/
    '';

    makeCacheWritable = true;
  };
}
