{...}:
{
	imports = [
		../services/networkmanager.nix
    ../services/pipewire.nix
	];
	services = {
		xserver.enable = true;
		displayManager.sddm.enable = true;
		desktopManager.plasma6.enable = true;
	};
}
