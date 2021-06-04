{ pkgs, config, ... }: {
  programs.fish.enable = true;

  users.users.raccoon = {
    isNormalUser = true;
    passwordFile = config.age.secrets.raccoon-password.path;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ (import ../../secrets/keys.nix).raccoon ];
  };
}
