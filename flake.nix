{
  description = "nnn-starter — an opinionated NixOS starter for the NNN stack (NixOS + Niri + Noctalia)";

  nixConfig = {
    extra-substituters = [
      "https://niri.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Scrollable-tiling Wayland compositor + NixOS/home-manager modules.
    # Deliberately does NOT follow our nixpkgs, so niri-flake's prebuilt
    # packages stay byte-identical to what niri.cachix.org has cached.
    niri.url = "github:sodiboo/niri-flake";

    # Noctalia desktop shell (v5 line). Pinned to the `cachix` branch: upstream
    # force-pushes there only after a commit's package is built and pushed to
    # noctalia.cachix.org, so `packages.default` is guaranteed to be a cache hit
    # (no ~hour-long C++ source build). It tracks `main` (v5), just slightly
    # behind. Crucially we do NOT make it follow our nixpkgs — that would
    # rebuild it against a different nixpkgs and miss the cache.
    noctalia.url = "github:noctalia-dev/noctalia-shell/cachix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    niri,
    noctalia,
    ...
  } @ inputs: let
    # The platform the NNN machine runs on.
    hostSystem = "x86_64-linux";

    # Personal, machine-local settings. Tracked with placeholder defaults but
    # marked skip-worktree so your real values never get committed:
    #   git update-index --skip-worktree local.nix
    local = import ./local.nix;
    inherit (local) username;

    # Helper so `nix fmt` / `nix develop` work from macOS or Linux.
    devSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs devSystems;
    pkgsFor = system: nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.My-Laptop = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = {inherit inputs username local;};
      modules = [
        niri.nixosModules.niri
        noctalia.nixosModules.default
        home-manager.nixosModules.home-manager

        ./hosts/My-Laptop
        ./modules/nixos

        {
          nixpkgs.config.allowUnfree = true;
          # Vesktop builds Vencord with pnpm, which nixpkgs currently marks
          # insecure. It's a build-time tool only; allow it by name so the rule
          # survives pnpm version bumps. (See modules/home/discord.nix.)
          nixpkgs.config.allowInsecurePredicate = pkg: nixpkgs.lib.getName pkg == "pnpm";
          nixpkgs.overlays = [
            niri.overlays.niri
            noctalia.overlays.default
            # nixpkgs dropped every google-chrome channel but stable; rebase the
            # upstream builder onto Google's beta .deb (see the overlay header).
            (import ./overlays/chrome-beta.nix)
          ];

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
          home-manager.extraSpecialArgs = {inherit inputs username local;};
          # niri-flake auto-imports its home modules (the config target) into
          # every user when home-manager runs as a NixOS module, so we only
          # add noctalia's here. Importing the niri ones again double-declares
          # `programs.niri.finalConfig`.
          home-manager.sharedModules = [
            noctalia.homeModules.default
          ];
          home-manager.users.${username} = import ./modules/home;
        }
      ];
    };

    # `nix fmt`
    formatter = forAllSystems (system: (pkgsFor system).alejandra);

    # `nix develop` — tooling for hacking on this repo.
    devShells = forAllSystems (system: {
      default = (pkgsFor system).mkShell {
        packages = with pkgsFor system; [
          alejandra
          statix
          deadnix
          nh
          nix-output-monitor
        ];
      };
    });
  };
}
