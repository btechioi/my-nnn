{
  pkgs,
  inputs,
  ...
}: {
  # The Noctalia desktop shell: bar, launcher, notifications, control center,
  # lock screen and wallpaper, all in one. Noctalia is now the theming driver
  # for the whole desktop: it owns the palette (Kanagawa, vendored below) and
  # re-themes the apps it covers via its template system — see [theme.templates].
  programs.noctalia = {
    enable = true;

    # Prebuilt package from noctalia.cachix.org (see modules/nixos/noctalia.nix).
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # Run as a systemd user service tied to the graphical (niri) session so it
    # starts and stops with your login.
    systemd.enable = true;

    # A Kanagawa palette with dark + light variants, mapped onto Noctalia's
    # semantic color roles so the shell, bar, panels, and every template follow
    # the same colors the base16 scheme (themes/kanagawa.yaml) used to set.
    customPalettes = {
      Kanagawa = {
        dark = {
          mPrimary = "7e9cd8"; # azure
          mOnPrimary = "16161d";
          mSecondary = "957fb8"; # violet
          mOnSecondary = "16161d";
          mTertiary = "ffa066"; # autumn orange
          mOnTertiary = "16161d";
          mError = "c34043"; # samurai red
          mOnError = "dcd7ba";
          mSurface = "1f1f28"; # sumi
          mOnSurface = "dcd7ba";
          mSurfaceVariant = "16161d"; # sumi-ink
          mOnSurfaceVariant = "727169";
          mOutline = "54546d"; # fuji gray
          mShadow = "000000";
          mHover = "223249"; # wave-1
          mOnHover = "dcd7ba";
          terminal = {
            background = "1f1f28";
            foreground = "dcd7ba";
            cursor = "c8c093";
            cursorText = "1f1f28";
            selectionBg = "223249";
            selectionFg = "dcd7ba";
            normal = {
              black = "16161d";
              red = "c34043";
              green = "76946a"; # katana green
              yellow = "c0a36e"; # ronin yellow
              blue = "7e9cd8"; # crystal blue
              magenta = "957fb8"; # wisteria
              cyan = "6a9589"; # dragon blue
              white = "c8c093"; # old white
            };
            bright = {
              black = "727169";
              red = "ff5d62"; # bright shrimp
              green = "98bb6c";
              yellow = "e0c68f";
              blue = "7fb4ca";
              magenta = "938aa9";
              cyan = "7aa89f";
              white = "dcd7ba";
            };
          };
        };
        light = {
          mPrimary = "1d4664"; # azure (dark)
          mOnPrimary = "f5e6d3";
          mSecondary = "7960a8"; # violet
          mOnSecondary = "f5e6d3";
          mTertiary = "9c5d22"; # autumn orange
          mOnTertiary = "f5e6d3";
          mError = "a8342f"; # samurai red
          mOnError = "f5e6d3";
          mSurface = "f5e6d3"; # paper
          mOnSurface = "2c2e34";
          mSurfaceVariant = "e8e0c8"; # paper-darker
          mOnSurfaceVariant = "585c66";
          mOutline = "b0a48a";
          mShadow = "9a9377";
          mHover = "e8e0c8";
          mOnHover = "2c2e34";
          terminal = {
            background = "f5e6d3";
            foreground = "2c2e34";
            cursor = "4d5a68";
            cursorText = "f5e6d3";
            selectionBg = "e8e0c8";
            selectionFg = "2c2e34";
            normal = {
              black = "16161d";
              red = "c34043";
              green = "76946a";
              yellow = "c0a36e";
              blue = "7e9cd8";
              magenta = "957fb8";
              cyan = "6a9589";
              white = "c8c093";
            };
            bright = {
              black = "727169";
              red = "ff5d62";
              green = "98bb6c";
              yellow = "e0c68f";
              blue = "7fb4ca";
              magenta = "938aa9";
              cyan = "7aa89f";
              white = "dcd7ba";
            };
          };
        };
      };
    };

    # Declarative Noctalia config, converted to ~/.config/noctalia/config.toml
    # and validated at build time by `noctalia config validate`.
    settings = {
      # Kanagawa everywhere, switching dark/light on the sunrise/sunset
      # schedule below. `theme-mode-toggle` (see Mod+D) flips it at runtime.
      theme = {
        mode = "auto"; # dark | light | auto
        source = "custom";
        custom_palette = "Kanagawa";
        templates = {
          enable_builtin_templates = true;
          # Templates render the active palette into each app and re-apply on
          # theme changes. Only apps whose config Noctalia can write to at
          # runtime are listed — store-managed symlinks (niri, starship, btop)
          # are left to Stylix.
          builtin_ids = [
            "ghostty"
            "gtk3"
            "gtk4"
          ];
        };
      };

      # Where the desktop lives — drives the auto dark/light schedule above.
      location = {
        latitude = 52.37;
        longitude = 4.90; # Amsterdam
      };

      # Ship the wallpaper through Noctalia.
      wallpaper = {
        enabled = true;
        default.path = ../../themes/wallpaper.png;
      };

      # A theme-mode toggle in the bar so dark/light can be flipped at a glance.
      bar = {
        main = {
          start = ["workspaces" "active_window"];
          center = ["clock"];
          end = ["sysmon" "volume" "network" "battery" "theme_mode" "tray"];
        };
      };
    };
  };
}
