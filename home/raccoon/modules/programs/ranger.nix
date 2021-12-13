{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.ranger;

  renderSettings = settings:
    (concatStringsSep "\n" (mapAttrsToList renderSetting settings)) + "\n";

  renderSetting = n: v: "set ${n} ${renderValue v}";

  renderValue = v:
    {
      bool = if v then "true" else "false";
      string = v;
    }.${builtins.typeOf v};

  renderBindings = renderMappingsSet false;
  renderAliases = renderMappingsSet true;

  renderMappingsSet = copy: mappings:
    renderMappings copy "" mappings.browser
    + renderMappings copy "c" mappings.console
    + renderMappings copy "p" mappings.pager
    + renderMappings copy "t" mappings.taskview;

  renderMappings = copy: context: mappings:
    (concatStringsSep "\n"
      (mapAttrsToList (renderMapping copy context) mappings)) + "\n";

  renderMapping = copy: context: n: v:
    "${if copy then "copy" else ""}${context}map ${n} ${v}";
in {
  options.programs.ranger = {
    enable = mkEnableOption "ranger";

    package = mkOption {
      type = types.package;
      default = pkgs.ranger;
      defaultText = literalExpression "pkgs.ranger";
      description = ''
        Package providing the <code>ranger</code> command.
      '';
    };

    bindings = {
      browser = mkOption {
        type = with types; attrsOf str;
        default = { };
      };

      console = mkOption {
        type = with types; attrsOf str;
        default = { };
      };

      pager = mkOption {
        type = with types; attrsOf str;
        default = { };
      };

      taskview = mkOption {
        type = with types; attrsOf str;
        default = { };
      };
    };

    aliases = {
      browser = mkOption {
        type = with types; attrsOf str;
        default = { };
      };

      console = mkOption {
        type = with types; attrsOf str;
        default = { };
      };

      pager = mkOption {
        type = with types; attrsOf str;
        default = { };
      };

      taskview = mkOption {
        type = with types; attrsOf str;
        default = { };
      };
    };

    settings = mkOption {
      type = with types; attrsOf (oneOf [ bool str ]);
      default = { };
      description = ''
        Settings for ranger.
      '';
    };

    rifleConfig = mkOption {
      type = types.str;
      default = "";
      description = ''
        Settings for rifle.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = {
      "ranger/rc.conf" = {
        text = renderSettings cfg.settings + renderBindings cfg.bindings
          + renderAliases cfg.aliases;
      };

      "ranger/rifle.conf" = { text = cfg.rifleConfig; };
    };
  };
}
