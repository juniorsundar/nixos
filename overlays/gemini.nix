final: prev: {
  gemini-cli = prev.buildNpmPackage rec {
    pname = "gemini-cli";
    version = "0.22.5";

    src = prev.fetchFromGitHub {
      owner = "google-gemini";
      repo = "gemini-cli";
      rev = "v${version}";
      hash = "sha256-3d9Lq3IulIgp4QGNtSvkwz10kfygX6vsmVdlU3lE6Gw=";
    };

    npmDepsHash = "sha256-6NqpkUgez7CqQAMDQW3Zdi86sF5qXseKXMw1Vw/5zWU=";
    nativeBuildInputs = [ prev.pkg-config ];
    buildInputs = [ prev.libsecret ];
    postInstall = ''
      cp -r packages $out/lib/node_modules/@google/gemini-cli/
    '';

    makeCacheWritable = true;
  };
}
