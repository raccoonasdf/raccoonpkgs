{ lib, config, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./nebula
    ./raccoon.fun
    ./users/raccoon.nix
  ];

  age.secrets.jame-environment = {
    file = ../secrets/jame-environment;
    owner = "jame";
  };

  boot = {
    kernelParams = [ "console=ttyS0" ];
    initrd.availableKernelModules = [ "virtio_pci" "ahci" "sd_mod" ];
    loader.grub = {
      enable = true;
      device = "nodev";
      copyKernels = true;
      fsIdentifier = "label";
      extraConfig = "serial; terminal_input serial; terminal_output serial";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/srv" = {
      device = "/dev/disk/by-label/srv";
      fsType = "ext4";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;

    # bandaid for linode networking issues
    dhcpcd.extraConfig = ''
      noarp
    '';
  };

  services.openssh.enable = true;

  services.jame = {
    enable = true;
    environmentFile = config.age.secrets.jame-environment.path;
  };

  services.fuzzball = {
    enable = true;
  };

  users.users.raccoon.extraGroups = [ "fuzzball" ];
}
