{ inputs
, lib
, config
, platform
, pkgs
, ...
}:let
pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${platform};
in {
  imports = [
    #./hardware-configuration.nix
    ../_mixins/hardware/systemdboot.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
    ../_mixins/services/bluetooth.nix
    ../_mixins/services/firewall.nix
    ../_mixins/services/fwupd.nix
    ../_mixins/services/docker.nix
    ../_mixins/services/thunderbolt.nix
    ../_mixins/services/boxes.nix
    ../_mixins/services/virtualbox.nix
    ../_mixins/services/focusrite.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8383e9c6-6a01-4127-a949-8605c424195f";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/B620-59D1";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/3f9712bd-740c-404e-8038-462078bb1a19";
    }
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];

      luks = {
        devices = {
          "luks-32488ed5-9166-49a6-8cf4-f47a1c20668b" = {
            device = "/dev/disk/by-uuid/32488ed5-9166-49a6-8cf4-f47a1c20668b";
            #keyFile = "/crypto_keyfile.bin";
          };

          "luks-f82aee8f-f2cd-4a43-bef2-5f865eeccfe9" = {
            device = "/dev/disk/by-uuid/f82aee8f-f2cd-4a43-bef2-5f865eeccfe9";
            #keyFile = "/crypto_keyfile.bin";
          };
        };
      };
    };

    kernelParams = [ "net.ipv4.ip_forward=1" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    resumeDevice = "/dev/disk/by-uuid/3f9712bd-740c-404e-8038-462078bb1a19";

    binfmt = {
      emulatedSystems = [ "aarch64-linux" ];
    };
  };

  time.timeZone = "Europe/Zurich";

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0u2u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
  hardware.enableAllFirmware = true;

  #enable Zen kernel
  #  boot.kernelPackages = pkgs.linuxPackages_zen;

  hardware.graphics = {
    # package = pkgs-unstable.mesa.drivers;
    enable = true;
    enable32Bit = true;
    # package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "ch";
      variant = "fr";
    };
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "laptop-nix"; # Define your hostname.
  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}
