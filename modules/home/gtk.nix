{pkgs, ...}: {
  # Icon theme for Nautilus and every other GTK app. GTK *colors* now come from
  # Noctalia's gtk3/gtk4 templates (see modules/home/noctalia.nix), which paint
  # adw-gtk3 with the Kanagawa palette and re-apply on theme changes. This
  # deliberately leaves the icon theme alone — without it, Nautilus falls back
  # to the bare hicolor/Adwaita defaults and looks plain.
  #
  # Papirus is the most complete Linux icon set (full folder + mime coverage).
  # Its default folder accent is already blue, which lines up with Kanagawa's
  # base0D (#7e9cd8) — so we use the plain prebuilt package straight from the
  # binary cache. (Recoloring via `.override { color = ...; }` would force a
  # slow from-source rebuild of the whole icon set for no visible gain here.)
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
