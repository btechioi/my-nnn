{...}: {
  # Ghostty colors are supplied by Noctalia's ghostty template (see
  # modules/home/noctalia.nix), which renders the active Kanagawa palette into
  # ~/.config/ghostty/themes/noctalia and keeps it in sync on theme changes.
  stylix.targets.ghostty.enable = false;

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    # `theme = noctalia` pulls in the file Noctalia's template generates;
    # everything else here is the ergonomic extras.
    settings = {
      theme = "noctalia";
      window-padding-x = 12;
      window-padding-y = 12;
      window-decoration = false;
      cursor-style = "block";
      cursor-style-blink = false;
      mouse-hide-while-typing = true;
      copy-on-select = "clipboard";
      confirm-close-surface = false;
      window-inherit-working-directory = true;
    };
  };
}
