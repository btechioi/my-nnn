{...}: {
  # Vesktop: a Wayland-native Discord client with Vencord baked in. Preferred
  # over the official `discord` package on Niri because screen-share with audio
  # works.
  programs.vesktop = {
    enable = true;

    # Vesktop's own (Electron shell) settings.
    settings = {
      minimizeToTray = true;
      # Let the Wayland compositor draw the window frame.
      customTitleBar = false;
    };

    # Nix manages the package, so stop Vencord self-updating or nagging.
    vencord.settings = {
      autoUpdate = false;
      autoUpdateNotification = false;
      notifyAboutUpdates = false;
    };
  };
}
