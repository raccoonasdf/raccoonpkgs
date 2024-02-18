let c = import ./config.nix;
  domain = "wiki.${c.domain}";
in { pkgs, raccoonpkgs, ... }: {
  services.dokuwiki = {
    webserver = "nginx";
    sites."${domain}" = {
      enable = true;
      package = pkgs.dokuwiki.overrideAttrs (self: super: {
        # i don't want hardcoded links to wiki:syntax and playground:playground
        postPhases = "modifyLangPhase";
        modifyLangPhase = ''
          lang=$out/share/dokuwiki/inc/lang/en
          rm $lang/edit.txt
          touch $lang/edit.txt
        '';
      });
      plugins = with raccoonpkgs.dokuwiki-plugins; [
        move wst yalist
      ];
      settings = {
        # Basic
        title = "${domain}";
        license = "";

        # Display
        typography = 0;
        sneaky_index = true;

        # Authentication
        useacl = true;
        autopasswd = false;
        superuser = "raccoon";

        # Advanced
        sepchar = "-";
        userewrite = true;
        updatecheck = false;

        plugin.wst = {
          namespace = "wiki:template";
        };
      };
    };
  };
  services.nginx.virtualHosts."wiki.${c.domain}" = {
    forceSSL = true;
    enableACME = true;
  };
}