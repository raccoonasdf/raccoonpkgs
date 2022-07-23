{ config, lib, pkgs, ... }:

with lib;

let cfg = config.raccoon.postgresql-activation;
in {
  options.raccoon.postgresql-activation = {
    ensureDatabasesWith = mkOption { type = types.attrsOf types.str; default = { }; };
    activationScripts = let
      scriptType = with types;
        let
          scriptOptions = {
            deps = mkOption {
              type = listOf str;
              default = [ ];
              description =
                "List of dependencies. The script will run after these.";
            };
          };
          text = mkOption {
            type = types.lines;
            description = "The content of the script.";
          };
        in either str (submodule { options = scriptOptions; });
    in mkOption {
      type = types.attrsOf scriptType;
      default = { };
    };
  };
  config = let
    scripts = cfg.activationScripts
      // optionalAttrs (cfg.ensureDatabasesWith != { }) {
        ensureDatabasesWith = (concatMapStrings (set: ''
          $PSQL -tAc "SELECT 1 FROM pg_database WHERE datname = '${set.name}'" | grep -q 1 || $PSQL -tAc 'CREATE DATABASE "${set.name}" WITH ${set.value}'
        '') (mapAttrsToList (nameValuePair) cfg.ensureDatabasesWith));
      };
    withDeps = mapAttrs (n: v: if isString v then noDepEntry v else v);
    withHeadlines = mapAttrs (n: v:
      v // {
        text = ''
          #### PostgreSQL activation script snippet ${n}:
          _localstatus=0
          ${v.text}

          if (( _localstatus > 0 )); then
            printf "PostgreSQL activation script snippet '%s' failed (%s)\n" "${n}" "$_localstatus"
          fi
        '';
      });
    scripts' = withHeadlines (withDeps scripts);
    script = ''
      #! ${pkgs.runtimeShell}

      _status=0
      trap "_status=1 _localstatus=\$?" ERR

      ${textClosureMap id (scripts') (attrNames scripts')}

      exit $_status
    '';
  in mkIf (scripts != { }) {
    systemd.services.postgresql.postStart = script;
  };
}
