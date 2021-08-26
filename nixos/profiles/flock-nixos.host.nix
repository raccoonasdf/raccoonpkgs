{ lib, config, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./graphical.nix
    ./users/raccoon.nix
  ];

  age.secrets.raccoon-password.file = ../secrets/flock-nixos-raccoon-password;

  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/771af309-6739-40cc-b7e7-139721a9a5c5";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/FB03-F628";
      fsType = "vfat";
    };
  };

  networking.interfaces.enp1s0.useDHCP = true;

  services.openssh.enable = true;
}
