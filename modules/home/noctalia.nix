{
  pkgs,
  inputs,
  ...
}: {
  # The Noctalia desktop shell: bar, launcher, notifications, control center,
  # lock screen and wallpaper, all in one.
  programs.noctalia = {
    enable = true;

    # Prebuilt package from noctalia.cachix.org (see modules/nixos/noctalia.nix).
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # Run as a systemd user service tied to the graphical (niri) session so it
    # starts and stops with your login.
    systemd.enable = true;

    # Configure the shell interactively via its control center (Mod+Space →
    # settings) and, once you're happy, pin the values declaratively here under
    # `settings = { ... };` (schema at docs.noctalia.dev).
    settings = {
      wallpaper = {
        enabled = true;
        # Wallpaper library: pick from this folder (and any subfolders) via the
        # wallpaper picker in the Control Center.
        directory = "/home/banumath/Pictures/Wallpapers";
      };

      # Noctalia's builtin/community app templates rewrite the configs that HM
      # already manages (starship, ghostty, gtk, btop, …), which breaks HM
      # activation. Keep Noctalia to shell/avatar/wallpaper only.
      theme.templates = {
        enable_builtin_templates = false;
        enable_community_templates = false;
      };

      # Face/avatar for the whole desktop: the Control Center, lock screen, and
      # when AccountsService is reachable (modules/nixos/users.nix) Noctalia
      # also pushes it to the system account's IconFile for login greeters.
      shell.avatar_path = ../../themes/avatar.png;
    };
  };

  # The standard XDG face file, so any tool that reads ~/.face (screensavers,
  # polkit/credential UIs, etc.) shows the avatar too.
  home.file.".face".source = ../../themes/avatar.png;
}
