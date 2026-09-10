# Chrome beta — nixpkgs only ships the stable channel, so we re-base the
# upstream `google-chrome` builder onto Google's beta .deb. To update, grab the
# current version + hash from:
#   https://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb
# (e.g. `nix hash file <deb>`) and bump `version` / `src.hash` below.
final: prev: let
  version = "154.0.8037.17";
  hash = "sha256-DPavhT3nQ2iaIk4PXLRjP4Ea39pbvBFys05mbaf+tIo=";
in {
  google-chrome-beta = prev.google-chrome.overrideAttrs (old: {
    pname = "google-chrome-beta";
    inherit version;

    src = prev.fetchurl {
      url = "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-beta/google-chrome-beta_${version}-1_amd64.deb";
      inherit hash;
    };

    # Upstream's installer hardcodes the *stable* layout (`dist=stable`,
    # `appname=chrome`, `com.google.Chrome.desktop`); the beta deb differs:
    #   opt/google/chrome-beta/,
    #   com.google.Chrome.beta.desktop,
    #   default-apps xml referencing .../google-chrome-beta.
    # Patch the install phase so the wrapper, desktop entries and icon naming
    # all follow the beta channel instead (substituteInPlace uses --replace-fail,
    # so every referenced path must match the actual beta layout).
    installPhase = prev.lib.pipe old.installPhase [
      (prev.lib.replaceStrings ["dist=stable"] ["dist=beta"])
      (prev.lib.replaceStrings ["appname=chrome"] ["appname=chrome-beta"])
      (prev.lib.replaceStrings ["com.google.Chrome.desktop"] ["com.google.Chrome.beta.desktop"])
      # Recent beta debs no longer ship the separate ANGLE libs, so the
      # `lib*GL*` glob matches nothing; guard the rpath fix so the literal
      # (unexpanded) pattern isn't passed to patchelf.
      (prev.lib.replaceStrings
        ["patchelf --set-rpath $rpath $out/share/google/$appname/lib*GL*"]
        ["for gl in $out/share/google/$appname/lib*GL*; do [ -e \"$gl\" ] && patchelf --set-rpath \"$rpath\" \"$gl\"; done"])
    ];

    # `postInstall` normally symlinks $out/bin/google-chrome -> google-chrome-stable,
    # which does not exist here; point it at the beta binary instead.
    postInstall = ''
      ln -s $out/bin/google-chrome-beta $out/bin/google-chrome
    '';

    meta = (old.meta or {}) // {mainProgram = "google-chrome-beta";};
  });
}