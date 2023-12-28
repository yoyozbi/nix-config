{inputs, pkgs, lib, platform, ...}:
{
	imports = [
		./hardware-configuration.nix
		../_mixins/hardware/lanzaboote.nix
		inputs.nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
		../_mixins/services/bluetooth.nix
		../_mixins/services/firewall.nix
		../_mixins/services/fwupd.nix
		#../_mixins/services/touchpad.nix
		../_mixins/services/thunderbolt.nix
	];
	nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}
