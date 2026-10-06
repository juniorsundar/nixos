{ pkgs, ... }:

let
  # Upstream only publishes a floating "latest" URL. When it moves on, the build
  # fails with a hash mismatch: paste the new hash and bump `version`
  # (see usr/lib/chatgpt/resources/linux-package-metadata.json in the .deb).
  chatgpt-codex = pkgs.stdenv.mkDerivation rec {
    pname = "chatgpt-codex";
    version = "26.930.61225";

    src = pkgs.fetchurl {
      url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
      hash = "sha256-uQqA+TU7wSpaW4RpUCqOV5SjxUo3HIiA4JTVAN5pW7g=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      dpkg
      makeWrapper
    ];

    buildInputs = with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      gdk-pixbuf
      glib
      gtk3
      libdrm
      libgbm
      libglvnd
      libnotify
      libusb1
      libxkbcommon
      nspr
      nss
      openssl
      pango
      systemd
      tpm2-tss
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      stdenv.cc.cc.lib
    ];

    # Qt file-dialog shims are optional; the musl prebuilds are never loaded on glibc.
    autoPatchelfIgnoreMissingDeps = [
      "libc.musl-x86_64.so.1"
      "libQt5Widgets.so.5"
      "libQt5Gui.so.5"
      "libQt5Core.so.5"
      "libQt6Widgets.so.6"
      "libQt6Gui.so.6"
      "libQt6Core.so.6"
    ];

    unpackPhase = "dpkg-deb -x $src .";

    # 300MB+ binaries; stripping is slow and the asar must stay untouched.
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/lib $out/share
      cp -r usr/lib/chatgpt $out/lib/chatgpt
      cp -r usr/share/applications usr/share/pixmaps $out/share/
      substituteInPlace $out/share/applications/chatgpt.desktop \
        --replace-fail "Exec=chatgpt" "Exec=$out/bin/chatgpt"
      runHook postInstall
    '';

    # Wrap after autoPatchelf so dlopen()ed libs (GL, Vulkan, udev) resolve.
    postFixup = ''
      makeWrapper $out/lib/chatgpt/ChatGPT $out/bin/chatgpt \
        --prefix LD_LIBRARY_PATH : ${
          pkgs.lib.makeLibraryPath [
            pkgs.libglvnd
            pkgs.vulkan-loader
            pkgs.systemd
            pkgs.libxkbcommon
          ]
        } \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.xdg-utils pkgs.git ]}
    '';

    meta = {
      description = "ChatGPT / Codex desktop app by OpenAI (repackaged .deb)";
      homepage = "https://developers.openai.com/codex/app";
      license = pkgs.lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      mainProgram = "chatgpt";
    };
  };
in
{
  environment.systemPackages = [ chatgpt-codex ];
}
