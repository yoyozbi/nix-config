{ inputs
, lib
, config
, platform
, pkgs
, ...
}: {
  imports = [
    ./disks.nix
    #./hardware-configuration.nix
    ../_mixins/hardware/lanzaboote.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
    ../_mixins/services/bluetooth.nix
    ../_mixins/services/firewall.nix
    ../_mixins/services/fwupd.nix
    ../_mixins/services/tpm.nix
    ../_mixins/services/touchpad.nix
    ../_mixins/services/openssh.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "tpm_tis" ];
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
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "ch";
      variant = "fr";
    };
  };

  services.iptsd.config = {
    Touchscreen = {
      DisableOnPalm = true;
      DisableOnStylus = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "surface-nix"; # Define your hostname.
  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}
