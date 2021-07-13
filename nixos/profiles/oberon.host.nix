{ lib, config, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./nebula
    ./raccoon.fun
    ./users/raccoon.nix
  ];

  age.secrets = {
    raccoon-password.file = ../secrets/oberon-raccoon-password;
    jame-environment = {
      file = ../secrets/jame-environment;
      owner = "jame";
    };
  };

  boot = {
    kernelParams = [ "console=ttyS0" ];
    initrd.availableKernelModules = [ "virtio_pci" "ahci" "sd_mod" ];
    loader.grub = {
      enable = true;
      version = 2;
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
  };

  services.openssh.enable = true;

  services.jame = {
    enable = true;
    environmentFile = config.age.secrets.jame-environment.path;
  };

  system.stateVersion = "20.09";
}
