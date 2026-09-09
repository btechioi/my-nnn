{pkgs, ...}: {
  # Stylix handles fonts, cursor, and the apps Noctalia doesn't re-theme (niri,
  # bat, btop, neovim, …). The shell, GTK, and Ghostty colors belong to Noctalia
  # (see modules/home/noctalia.nix), so we opt those targets out below.
  stylix = {
    enable = true;
    polarity = "dark";

    # Noctalia is now the theming driver for the apps whose colors it can
    # render at runtime (see modules/home/noctalia.nix -> [theme.templates]).
    # Turn Stylix off for those so the two systems never fight over the same
    # file; Stylix keeps providing fonts, cursor, and the rest of the desktop.
    targets.gtk.enable = false;
    targets.ghostty.enable = false;

    # Kanagawa, vendored in-repo so the build never depends on whatever version
    # of `base16-schemes` happens to be pinned. To use an upstream scheme
    # instead: stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    base16Scheme = ../../themes/kanagawa.yaml;

    # "Static mind, like the sea" (静心如海) — a meditating pepe before Hokusai's
    # Great Wave off Kanagawa, vendored in-repo (pngquant-optimized).
    image = ../../themes/wallpaper.png;

    # A hint of terminal transparency for that layered desktop look.
    opacity.terminal = 0.95;

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.maple-mono.NF;
        name = "Maple Mono NF";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        terminal = 12;
        applications = 11;
        desktop = 11;
        popups = 11;
      };
    };
  };
}
