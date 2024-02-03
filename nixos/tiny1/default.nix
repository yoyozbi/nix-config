{hostname, inputs, lib, platform, username,modulesPath, ...}:
{
	imports = [
		(modulesPath + "/profiles/qemu-guest.nix")
		inputs.nixos-hardware.nixosModules.common-cpu-amd
		inputs.nixos-hardware.common-pc
		inputs.nixos-hardware.common-pc-ssd
		(import ./disks.nix { })
		../_mixins/hardware/systemd-boot.nix
		../_mixins/services/cachix.nix
		../_mixins/services/openssh.nix
		../_mixins/services/grub.nix
		../_mixins/services/firewall.nix
		../_mxins/services/networkmanager.nix
	];

	boot = {
		initrd = {
			availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
			kernelModules = [ "nvme" ];
		};
		cleanTmpDir = true;
	};

	zramSwap.enable = true;
	networking = {
		hostname = "tiny1";
		domain = "";
	};
}
