{ pkgs, config, ... }: {
  programs.fish.enable = true;

  # no password logins by default
  users.users.raccoon = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ (import ../../secrets/keys.nix).raccoon ];
  };
}
