{ config, pkgs, raccoonpkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  mozillaConfigPath =
    if isDarwin then "Library/Application Support/Mozilla" else ".mozilla";

  firefoxConfigPath = if isDarwin then
    "Library/Application Support/Firefox"
  else
    "${mozillaConfigPath}/firefox";

  profilesPath =
    if isDarwin then "${firefoxConfigPath}/Profiles" else firefoxConfigPath;
in {
  programs.firefox = {
    enable = true;

    profiles.raccoon = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        * {
          font-family: ${config.raccoon.styles.fonts.body} !important;
          font-size: 9pt !important;
        }
      '' + builtins.readFile ./userChrome.css;
    };
  };

  # firefox doesn't sync search engines :(
  home.file."${profilesPath}/${config.programs.firefox.profiles.raccoon.path}/search.json.mozlz4".source =
    pkgs.runCommand "search.json.mozlz4" {
      nativeBuildInputs = [ raccoonpkgs.dejsonlz4 pkgs.jq ];
    } "jq -c . ${./search.json} | jsonlz4 - $out";

  # TODO: depend on Firefox Sync less
}
