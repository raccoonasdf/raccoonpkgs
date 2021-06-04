{ lib, config, pkgs, ... }: {
  users.mutableUsers = lib.mkBefore false;

  networking = {
    hostId = builtins.substring 0 8
      (builtins.hashString "md5" config.networking.hostName);
    useDHCP = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  boot.zfs = {
    forceImportRoot = false;
    forceImportAll = false;
  };

  nix = {
    gc = {
      automatic = lib.mkBefore true;
      options = lib.mkBefore "--delete-older-than 7d";
    };
    trustedUsers = [ "@wheel" ];
  };

  security.sudo.wheelNeedsPassword = lib.mkBefore false;

  environment.systemPackages = with pkgs; [ git git-crypt home-manager ];
}
