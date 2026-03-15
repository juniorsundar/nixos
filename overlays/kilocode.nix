final: prev: {
  kilocode-cli = prev.stdenv.mkDerivation rec {
    pname = "kilocode-cli";
    version = "7.0.47"; # Update to the version you need

    src = prev.fetchurl {
      url = "https://github.com/Kilo-Org/kilocode/releases/download/v${version}/kilo-linux-x64.tar.gz";
      hash = "sha256-jDkQmN1fb1x0/ssTPzaBum48p3tPIQyEYUIF8sLo1ds="; # Run the build once, let it fail, and paste the real hash here
    };

    sourceRoot = ".";

    dontFixup = true;

    installPhase = ''
      mkdir -p $out/bin
      cp kilo $out/bin/kilo
      chmod +x $out/bin/kilo
    '';
  };
}
