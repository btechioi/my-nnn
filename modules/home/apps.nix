{
  pkgs,
  ...
}: {
  # GUI desktop apps. Browsers and file managers live here rather than in the
  # CLI bundle.
  home.packages = [
    # Nautilus (GNOME Files): a sensible GTK file manager. Pairs with the gvfs
    # service enabled in modules/nixos/desktop.nix for trash + mounting, and
    # backs the browser's "open/save" file picker via the gtk xdg portal.
    pkgs.nautilus

    # Google Chrome (beta) — the default and only browser. nixpkgs only ships
    # the stable channel, so it's built from Google's official beta deb by
    # overlays/chrome-beta.nix. (Unfree — allowed in flake.nix.)
    pkgs.google-chrome-beta
  ];

  # Make Chrome the default handler for web content (and $BROWSER for tools
  # like gh / git). zed.nix claims the text/* source types; Chrome only takes
  # the web ones, so there is no overlap.
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "google-chrome-beta.desktop";
    "x-scheme-handler/https" = "google-chrome-beta.desktop";
    "x-scheme-handler/ftp" = "google-chrome-beta.desktop";
    "text/html" = "google-chrome-beta.desktop";
    "application/xhtml+xml" = "google-chrome-beta.desktop";
  };
  home.sessionVariables.BROWSER = "google-chrome-beta";
}