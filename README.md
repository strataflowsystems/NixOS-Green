# Hermes Theme Flake

This repo stores the Hermes desktop theme as reproducible Nix inputs.

It intentionally tracks theme assets and theme-selecting config only. Runtime
state such as browser cookies, caches, logs, auth files, lock files, and local
databases should stay outside the repo.

## Use With Home Manager

Add this flake as an input and import the module:

```nix
{
  inputs.hermes-theme.url = "github:strataflowsystems/NixOS-Green";

  outputs = { home-manager, hermes-theme, ... }: {
    homeConfigurations.your-user = home-manager.lib.homeManagerConfiguration {
      modules = [
        hermes-theme.homeManagerModules.default
        {
          hermesTheme.enable = true;
          hermesTheme.firefoxProfile = "default";
        }
      ];
    };
  };
}
```

Set `hermesTheme.firefoxProfile` to your actual Firefox profile directory if
you want the included `userChrome.css` and `userContent.css` linked.

## Included

- KDE Plasma look-and-feel and desktop theme assets.
- Aurorae window decoration variants.
- Iridescent color schemes.
- GTK 3/4, Qt/KDE, Kitty, and Firefox chrome theme files.
- HermesCode wallpaper.

## Not Included

Third-party icon packs are not vendored in the public release. Use your
preferred icon theme, or install the icon packs separately if you want to match
the original local desktop exactly.

If you are not using Home Manager yet, keep this repo as the canonical source
for the theme and copy/link files manually until your user config is migrated.

## Save Future Changes

After tweaking the live desktop theme:

```sh
FIREFOX_PROFILE=your-profile.default ./scripts/update-from-live.sh
git diff --stat
git add .
git commit -m "Update Hermes theme"
```

That gives each visual change a recoverable Git history.

## Validate

```sh
nix flake check
nix build
```

## License

This theme is published under GPL-2.0-or-later, matching the bundled Plasma
look-and-feel license. See
`assets/local/share/plasma/look-and-feel/Iridiscent-round/LICENSE.md`.
