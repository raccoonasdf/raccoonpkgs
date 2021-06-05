{ modulesPath, lib, raccoonpkgs, inputs, ... }: {
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  networking.useDHCP = lib.mkForce true;

  environment.systemPackages = [ raccoonpkgs.raccoon-install-tools ];

  isoImage.isoBaseName = "raccoon-nixos";
}
