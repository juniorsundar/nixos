{
  lib,
  buildNpmPackage,
  fetchurl,
  nodejs_24,
  jq,
}:

# Packages the prebuilt npm tarball (Next.js standalone bundle already inside).
# Everything mutable lives in $DATA_DIR at runtime, so the store path stays read-only.
#
# Bump: change version + hash, then regenerate ./package-lock.json:
#   tar xzf omniroute-X.tgz && cd package
#   jq 'del(.devDependencies, .workspaces, .scripts)' package.json > p && mv p package.json
#   npm install --package-lock-only --ignore-scripts --legacy-peer-deps
# and set npmDepsHash = lib.fakeHash to get the new one.
buildNpmPackage rec {
  pname = "omniroute";
  version = "3.8.53";

  src = fetchurl {
    url = "https://registry.npmjs.org/omniroute/-/omniroute-${version}.tgz";
    hash = "sha256-VH+l6E7OR975GoznhsSCK2A741tQxUWnHF+mWYNCAPA=";
  };

  nodejs = nodejs_24;
  npmDepsHash = "sha256-juRdnzNBtavICvSIiTnSy01wBl8slnffSgbHAyWfvtU=";
  npmFlags = [ "--legacy-peer-deps" ]; # matches upstream Dockerfile

  # Lockfile was generated against this stripped manifest; dev deps/workspaces are build-only.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    ${lib.getExe jq} 'del(.devDependencies, .workspaces, .scripts)' package.json > package.json.new
    mv package.json.new package.json
  '';

  dontNpmBuild = true;
  # Native deps we need ship prebuilds (better-sqlite3, sharp, onnxruntime); install
  # scripts would try to download/compile, which fails in the sandbox.
  npmRebuildFlags = [ "--ignore-scripts" ];

  # Upstream postinstall: copies native bindings into the standalone dist/ tree.
  # Its .env.example -> .env copy is dropped: config belongs in $DATA_DIR/.env.
  postInstall = ''
    pkgRoot=$out/lib/node_modules/omniroute
    (cd $pkgRoot && HOME=$TMPDIR ${nodejs}/bin/node scripts/build/postinstall.mjs)
    rm -f $pkgRoot/.env
  '';

  meta = {
    description = "Unified AI router with 160+ providers";
    homepage = "https://github.com/diegosouzapw/OmniRoute";
    license = lib.licenses.mit;
    mainProgram = "omniroute";
    platforms = lib.platforms.linux;
  };
}
