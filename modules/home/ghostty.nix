{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    # Font (Maple Mono NF) and colors come from the system fontconfig defaults
    # and the terminal's own fallback palette; these are the ergonomic extras.
    settings = {
      window-padding-x = 12;
      window-padding-y = 12;
      window-decoration = false;
      cursor-style = "block";
      cursor-style-blink = false;
      mouse-hide-while-typing = true;
      copy-on-select = "clipboard";
      confirm-close-surface = false;
      window-inherit-working-directory = true;
      # A hint of transparency for that layered desktop look.
      background-opacity = 0.95;
    };
  };
}
