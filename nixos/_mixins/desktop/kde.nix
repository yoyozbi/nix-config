{...}:
{
	services.xserver.enable = true;
	services.xserver.displayManager.sddm.enable = true;
	services.xserver.desktopManager.plasma6.enable = true;

	qt = {
  	enable = true;
  	platformTheme = "gnome";
  	style = "adwaita-dark";
	};
}
