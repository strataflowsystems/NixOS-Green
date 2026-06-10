{
  description = "Hermes desktop theme assets";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "hermes-theme";
            version = "0.1.0";
            src = ./assets;
            dontFixup = true;

            installPhase = ''
              runHook preInstall
              mkdir -p "$out/share/hermes-theme"
              cp -a . "$out/share/hermes-theme/"
              runHook postInstall
            '';
          };
        });

      homeManagerModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.hermesTheme;
          theme = self.packages.${pkgs.system}.default;
          root = "${theme}/share/hermes-theme";
        in
        {
          options.hermesTheme = {
            enable = lib.mkEnableOption "Hermes desktop theme";

            firefoxProfile = lib.mkOption {
              type = lib.types.str;
              default = "default";
              description = "Firefox profile directory that receives chrome CSS.";
            };
          };

          config = lib.mkIf cfg.enable {
            home.file = {
              ".gtkrc-2.0".source = "${root}/home/gtkrc-2.0";

              ".config/gtk-3.0".source = "${root}/config/gtk-3.0";
              ".config/gtk-4.0".source = "${root}/config/gtk-4.0";
              ".config/gtkrc".source = "${root}/config/gtkrc";
              ".config/gtkrc-2.0".source = "${root}/config/gtkrc-2.0";
              ".config/kitty".source = "${root}/config/kitty";

              ".config/kdeglobals".source = "${root}/config/kdeglobals";
              ".config/kdedefaults".source = "${root}/config/kdedefaults";
              ".config/kded6rc".source = "${root}/config/kded6rc";
              ".config/kiorc".source = "${root}/config/kiorc";
              ".config/ksplashrc".source = "${root}/config/ksplashrc";
              ".config/kwinrc".source = "${root}/config/kwinrc";
              ".config/plasmashellrc".source = "${root}/config/plasmashellrc";
              ".config/Trolltech.conf".source = "${root}/config/Trolltech.conf";
              ".config/xsettingsd".source = "${root}/config/xsettingsd";

              ".config/mozilla/firefox/${cfg.firefoxProfile}/chrome".source =
                "${root}/config/mozilla/firefox/default/chrome";

              ".local/share/aurorae/themes/Colorful-Dark-Aurorae-6".source =
                "${root}/local/share/aurorae/themes/Colorful-Dark-Aurorae-6";
              ".local/share/aurorae/themes/Colorful-Dark-Color-Aurorae-6".source =
                "${root}/local/share/aurorae/themes/Colorful-Dark-Color-Aurorae-6";
              ".local/share/aurorae/themes/Colorful-Blur-Dark-Aurorae-6".source =
                "${root}/local/share/aurorae/themes/Colorful-Blur-Dark-Aurorae-6";
              ".local/share/color-schemes".source = "${root}/local/share/color-schemes";
              ".local/share/plasma/desktoptheme".source = "${root}/local/share/plasma/desktoptheme";
              ".local/share/plasma/look-and-feel".source = "${root}/local/share/plasma/look-and-feel";
              ".local/share/wallpapers/HermesCode".source = "${root}/local/share/wallpapers/HermesCode";
            };
          };
        };
    };
}
