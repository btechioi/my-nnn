{pkgs, ...}: {
  # Icon theme for Nautilus and every other GTK app. GTK *colors* fall back to
  # the Adwaita defaults now that system-wide theming is gone; the icon theme
  # is a separate concern — without this, Nautilus falls back to the bare
  # hicolor/Adwaita defaults and looks plain.
  #
  # Papirus is the most complete Linux icon set (full folder + mime coverage).
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Keep the Bibata cursor that the previous theming setup applied.
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };
}
