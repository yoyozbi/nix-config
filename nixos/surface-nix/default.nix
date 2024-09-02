{ inputs
, lib
, config
, platform
, ...
}: {
  imports = [
		./disks.nix
    #./hardware-configuration.nix
    ../_mixins/hardware/systemdboot.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
    ../_mixins/services/bluetooth.nix
    ../_mixins/services/firewall.nix
    ../_mixins/services/fwupd.nix
    ../_mixins/services/tpm.nix
  ];


  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme"  "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    kernelParams = [ "net.ipv4.ip_forward=0" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  time.timeZone = "Europe/Zurich";

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0u2u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
  hardware.enableAllFirmware = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "ch";
      variant = "fr";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "surface-nix"; # Define your hostname.
  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}
