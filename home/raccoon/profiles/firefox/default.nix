{ config, pkgs, raccoonpkgs, lib, ... }:
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

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      betterttv
      greasemonkey
      privacy-badger
      stylus
      tree-style-tab
      ublock-origin
      (buildFirefoxXpiAddon {
        pname = "tree-style-tab-mouse-wheel";
        version = "1.5";
        addonId = "tst-wheel_and_double@dontpokebadgers.com";
        url = "https://addons.mozilla.org/firefox/downloads/file/3473925/tree_style_tab_mouse_wheel-1.5-fx.xpi";
        sha256 = "c9bad51fceb18e7323465fd25dd81df7c6cb3f5dbaf878dc6f84e8963c492bb5";
        meta = with lib; {
          homepage = "https://addons.mozilla.org/en-US/firefox/addon/tree-style-tab-mouse-wheel/";
          description = "Extends Tree Style Tab to allow tab changing by mouse wheel scrolling and reloading a tab when double clicking it.";
          license = licenses.mpl20;
          platforms = platforms.all;
        };
      })
    ];

    profiles.raccoon = {
      isDefault = true;

      settings = {
        # enable chrome/* customizations
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # disable toolkit telemetry stuff
        # https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/internals/preferences.html
        "toolkit.telemetry.unified" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;

        # reload last session on startup, but still warn on quit
        "browser.startup.page" = 3;
        "browser.warnOnQuit" = true;
        "browser.sessionstore.warnOnQuit" = true;

        # no home or new tab page
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = false;

        "browser.toolbars.bookmarks.visibility" = "always";

        # not necessary, just prevents url bar from erronously displaying
        # "Google" on first run
        "browser.urlbar.placeholderName" = "DuckDuckGo";

        # disable first-run onboarding
        "browser.aboutwelcome.enabled" = false;

        # enable "browser toolbox" for inspecting browser chrome
        "devtools.chrome.enabled" = true;
        "devtools.debugger.remote-enabled" = true;

        "devtools.inspector.showUserAgentStyles" = true;

        "devtools.theme" = "dark";

        # disable all the autofill prompts
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "signon.rememberSignons" = false;

        "general.smoothscroll" = false;

        # disable spellcheck for form inputs
        "layout.spellcheckDefault" = 0;
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

  # TODO: figure out if i can set extension configs somehow
  # they're in a bunch of mutable sqlite dbs so it'll probably be a hack
}
