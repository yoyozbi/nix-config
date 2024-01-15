{inputs, pkgs, lib, config, platform, ...}:
{
	imports = [
		#./hardware-configuration.nix
		../_mixins/hardware/lanzaboote.nix
		inputs.nixos-hardware.nixosModules.dell-xps-15-9520
		../_mixins/services/bluetooth.nix
		../_mixins/services/firewall.nix
		../_mixins/services/fwupd.nix
		../_mixins/services/docker.nix
		../_mixins/services/thunderbolt.nix
		../_mixins/services/boxes.nix
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

		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [];

		resumeDevice = "/dev/disk/by-uuid/1a8f4d0f-ff23-4c86-9f65-de2388610e00";
	};

 time.timeZone = "Europe/Zurich";

 networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0u2u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
	hardware.enableAllFirmware = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "laptop-nix"; # Define your hostname.
	nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}
