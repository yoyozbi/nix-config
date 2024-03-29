{inputs, pkgs, lib, config, platform, ...}:
{
	imports = [
		#./hardware-configuration.nix
		../_mixins/hardware/lanzaboote.nix
		inputs.nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
		../_mixins/services/bluetooth.nix
		../_mixins/services/firewall.nix
		../_mixins/services/fwupd.nix
		../_mixins/services/docker.nix
		../_mixins/services/thunderbolt.nix
		../_mixins/services/boxes.nix
		../_mixins/services/virtualbox.nix
	];

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-uuid/84263630-ecdf-4ba5-a85c-78a2eb9f99f7";
      fsType = "ext4";
		};

		"/boot" = {
			device = "/dev/disk/by-uuid/B620-59D1";
      fsType = "vfat";
		};
	};
	swapDevices =
    [ 
			{
			device = "/dev/disk/by-uuid/1a8f4d0f-ff23-4c86-9f65-de2388610e00"; 
			}
    ];


	boot = {
		initrd = {
			secrets = {
				"/crypto_keyfile.bin" = null;
			};

			availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
			kernelModules = [];

			luks = {
				devices = {
					"luks-7efb93f8-93b9-40f2-b150-4ad3e86f8b6d" = {
						device = "/dev/disk/by-uuid/7efb93f8-93b9-40f2-b150-4ad3e86f8b6d";
						keyFile = "/crypto_keyfile.bin";
					};

					"luks-ff068a18-3c9c-4a0c-a68f-9e656a63ee9e" = {
						device = "/dev/disk/by-uuid/ff068a18-3c9c-4a0c-a68f-9e656a63ee9e";
						#keyFile = "/crypto_keyfile.bin";
					};
				};

			};
		};

		kernelParams = [ "net.ipv4.ip_forward=0"];
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [];

		resumeDevice = "/dev/disk/by-uuid/1a8f4d0f-ff23-4c86-9f65-de2388610e00";

		binfmt = {
			emulatedSystems = ["aarch64-linux"];
		};
	};

 time.timeZone = "Europe/Zurich";

 networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0u2u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
	hardware.enableAllFirmware = true;


	#enable Zen kernel
	boot.kernelPackages = pkgs.linuxPackages_zen;

	 hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.

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
		};
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "laptop-nix"; # Define your hostname.
	nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}
