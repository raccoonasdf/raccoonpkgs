{ modulesPath, lib, pkgs, inputs, ... }: {
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  networking.useDHCP = lib.mkForce true;

  environment.systemPackages = [ pkgs.rac.raccoon-install-tools ];

  isoImage.isoBaseName = "raccoon-nixos";
}
