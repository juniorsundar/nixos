final: prev: {
  gemini-cli = prev.buildNpmPackage rec {
    pname = "gemini-cli";
    version = "0.22.4";

    src = prev.fetchFromGitHub {
      owner = "google-gemini";
      repo = "gemini-cli";
      rev = "v${version}";
      hash = "sha256-gYh8GpuBwkowdBNCYkh7w2MFSTw8xXYO4XbQBezzFlQ=";
    };

    npmDepsHash = "sha256-f5s2T+826rZU8IXe4fv26JiR3laPunbKeJSRnst6upw=";
    nativeBuildInputs = [ prev.pkg-config ];
    buildInputs = [ prev.libsecret ];
    postInstall = ''
      cp -r packages $out/lib/node_modules/@google/gemini-cli/
    '';

    makeCacheWritable = true;
  };
}
