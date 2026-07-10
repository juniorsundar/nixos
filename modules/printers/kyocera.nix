{ pkgs, ... }:

let
  cupsUsername = "junior.sundar";

  pythonWithReportlab = pkgs.python3.withPackages (pythonPackages: [
    pythonPackages.reportlab
    pythonPackages.setuptools
  ]);

  kyoceraTaskalfa4053ci = pkgs.stdenv.mkDerivation {
    pname = "kyocera-taskalfa-4053ci-driver";
    version = "9.4-local";

    src = ./kyodialog_9.4-0_amd64.deb;

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      dpkg
      makeWrapper
    ];

    buildInputs = with pkgs; [
      cups
      dbus
      zlib
      stdenv.cc.cc.lib
    ];

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x "$src" .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p \
        $out/lib/cups/filter \
        $out/share/cups/model/kyocera \
        $out/share/kyocera9.4

      # The deb contains both CS and TASKalfa 4053ci KPDL/PostScript PPDs.
      # Install the TASKalfa model explicitly, plus the CS alias in case CUPS
      # exposes that naming variant during printer discovery.
      cp usr/share/kyocera9.4/ppd9.4/Kyocera_TASKalfa_4053ci.ppd \
        $out/share/cups/model/kyocera/
      cp usr/share/kyocera9.4/ppd9.4/Kyocera_CS_4053ci.ppd \
        $out/share/cups/model/kyocera/

      # Also expose generic raster/PCL and PDF PPDs from the same driver bundle.
      # These are useful fallback queues for image-heavy PDFs that trigger
      # PostScript /limitcheck errors on the printer's KPDL interpreter.
      cp usr/share/kyocera9.4/ppd9.4/Kyocera_Generic_Color_A3_PCL.ppd \
        $out/share/cups/model/kyocera/
      cp usr/share/kyocera9.4/ppd9.4/Kyocera_Generic_Color_A3_PDF.ppd \
        $out/share/cups/model/kyocera/

      cp usr/lib/cups/filter/kyofilter* $out/lib/cups/filter/
      chmod +x $out/lib/cups/filter/kyofilter*

      # Keep the vendor Python support modules available to kyofilter_pre_H
      # (notably the vendored PyPDF3 package).
      cp -R usr/share/kyocera9.4/Python $out/share/kyocera9.4/

      # CUPS on NixOS builds a ServerBin symlink tree from driver packages;
      # absolute /usr/lib/cups/filter paths from the Debian PPDs will not exist.
      for ppd in $out/share/cups/model/kyocera/*.ppd; do
        if grep -q "/usr/lib/cups/filter/" "$ppd"; then
          substituteInPlace "$ppd" --replace-fail "/usr/lib/cups/filter/" ""
        fi
      done

      # Patch the Python pre-filter to run with Nix's Python and dependencies.
      substituteInPlace $out/lib/cups/filter/kyofilter_pre_H \
        --replace-fail "#! /usr/bin/python3" "#! ${pythonWithReportlab}/bin/python3"
      wrapProgram $out/lib/cups/filter/kyofilter_pre_H \
        --prefix PYTHONPATH : "$out/share/kyocera9.4/Python/PyPDF3-1.0.6"

      runHook postInstall
    '';
  };
in
{
  services.printing = {
    enable = true;
    drivers = [
      kyoceraTaskalfa4053ci
      pkgs.cups-filters
      pkgs.ghostscript
    ];

    # Make CUPS submit jobs using the secure-print username.
    # This is system-wide, so it is best for a single-user laptop.
    clientConf = ''
      User ${cupsUsername}
    '';
  };

  # Helps GUI apps launched from Plasma inherit the same CUPS username.
  environment.sessionVariables = {
    CUPS_USER = cupsUsername;
  };

  # Compatibility for existing CUPS queues created from the original Debian PPDs.
  # Those queue-local PPDs may still reference absolute Debian filter paths like
  # /usr/lib/cups/filter/kyofilter_H. New queues created from the patched PPDs do
  # not need this, but the links keep old queues working after rebuild-switch.
  systemd.tmpfiles.rules = [
    "d /usr/lib 0755 root root -"
    "d /usr/lib/cups 0755 root root -"
    "d /usr/lib/cups/filter 0755 root root -"
    "L+ /usr/lib/cups/filter/kyofilter_H - - - - ${kyoceraTaskalfa4053ci}/lib/cups/filter/kyofilter_H"
    "L+ /usr/lib/cups/filter/kyofilter_kpsl_H - - - - ${kyoceraTaskalfa4053ci}/lib/cups/filter/kyofilter_kpsl_H"
    "L+ /usr/lib/cups/filter/kyofilter_pdf_H - - - - ${kyoceraTaskalfa4053ci}/lib/cups/filter/kyofilter_pdf_H"
    "L+ /usr/lib/cups/filter/kyofilter_pre_H - - - - ${kyoceraTaskalfa4053ci}/lib/cups/filter/kyofilter_pre_H"
    "L+ /usr/lib/cups/filter/kyofilter_ras_H - - - - ${kyoceraTaskalfa4053ci}/lib/cups/filter/kyofilter_ras_H"
  ];
}
