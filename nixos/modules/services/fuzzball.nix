{ config, pkgs, raccoonpkgs, lib, ... }:
with lib;
let cfg = config.services.fuzzball;
in {
  options.services.fuzzball = {
    enable = mkEnableOption "fuzzball";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/fuzzball";
      description = ''
        Data directory for fuzzball, where `data`, `logs`, and `muf` live.
      '';
    };

    port = mkOption {
      # config.h TINYPORT default
      default = 4201;
      type = with types; nullOr port;
      description = "Non-SSL port to listen on.";
    };

    sport = mkOption {
      default = null;
      type = with types; nullOr port;
      description = "SSL port to listen on.";
    };

    dbfile = mkOption {
      default = "std-db.db";
      type = types.str;
      description = "Name of dbfile inside $GAMEDIR/data/";
    };

    package = mkOption {
      type = types.package;
      default = raccoonpkgs.fuzzball;
      defaultText = "raccoonpkgs.fuzzball";
      description = "fuzzball package to use.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = optional (cfg.port != null) cfg.port ++ optional (cfg.sport != null) cfg.sport;
    
    systemd.services.fuzzball = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = "fuzzball";
        Restart = "always";
        PermissionsStartOnly = true;
      };
      preStart = ''
        dataDir="${cfg.dataDir}"

        if [ ! -d "$dataDir" ]; then
          umask 077
          skel="${cfg.package}/share/doc/fbmuck/game"
          mkdir -p "$dataDir"
          echo "Populating newly created $dataDir with defaults from $skel"
          cp -r "$skel/." "$dataDir"
          chmod -R u=rwX "$dataDir"
        fi

        chown -R "fuzzball:fuzzball" "${cfg.dataDir}"
      '';
      script = ''
        # based on the `fb-restart` script distributed with fuzzball

        SERVER="${cfg.package}/bin/fbmuck"

        GAMEDIR="${cfg.dataDir}"

        DBIN="$GAMEDIR/data/${cfg.dbfile}"
        DBOUT="$DBIN.new"
        DBOLD="$DBIN.old"


        cd "$GAMEDIR"

        umask 077

        PIDFILE="$GAMEDIR/fbmuck.pid"
        if [ -r "$PIDFILE" ]; then
          if kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
            echo "This server is already running.  Restart aborted."
            exit 1
          fi
        fi

        PANICDB="$DBOUT.PANIC"
        if [ -r $PANICDB ]; then
          end=$(tail -1 $PANICDB)
          if [ "x$end" = "x***END OF DUMP***" ]; then
        		mv $PANICDB $DBOUT
          else
        		echo "Warning: PANIC dump failed"
          fi
        fi

        if [ -r "$DBOUT" ]; then
          mv -f "$DBIN" "$DBOLD"
          mv "$DBOUT" "$DBIN"
        fi

        if [ ! -r "$DBIN" ]; then
          echo "Hey!  The $DBIN file has to exist and be readable to restart the server!"
          echo "DB files can be found in the fuzzball package in doc/fbmuck/dbs"
          echo "Restart attempt aborted."
          exit 2            
        fi

        end=$(tail -1 $DBIN)
        if [ "x$end" != 'x***END OF DUMP***' ]; then
        	echo "WARNING!  The $DBIN file is incomplete and therefore corrupt!"
        	echo "Restart attempt aborted."
        	exit 3
        fi

        "$SERVER" \
          -nodetach \
          -gamedir "$GAMEDIR" \
          -dbin "$DBIN" \
          -dbout "$DBOUT" \
          ${optionalString (cfg.port != null) "-port ${toString cfg.port} \\"}
          ${
            optionalString (cfg.sport != null) "-sport ${toString cfg.sport} \\"
          }
      '';

    };

    users = {
      users.fuzzball = {
        isSystemUser = true;
        group = "fuzzball";
      };
      groups.fuzzball = { };
    };
  };
}
