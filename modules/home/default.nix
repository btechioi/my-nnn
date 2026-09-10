{username, ...}: {
  imports = [
    ./cli.nix
    ./zsh.nix
    ./starship.nix
    ./git.nix
    ./ghostty.nix
    ./neovim.nix
    ./zed.nix
    ./gtk.nix
    ./niri.nix
    ./noctalia.nix
    ./direnv.nix
    ./opencode.nix
    ./apps.nix
    ./media.nix
    ./discord.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Match system.stateVersion in hosts/My-Laptop/default.nix. Don't bump casually.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
