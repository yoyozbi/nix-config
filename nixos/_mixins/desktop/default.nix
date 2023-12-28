{desktop, lib, pkgs, ...}:
{
	imports = []
		++ lib.optional (builtins.pathExists (./. + "/${desktop}.nix")) ./${desktop}.nix;

		hardware = {
			opengl = {
				enable = true;
				driSupport = true;
			};
		};

		programs.dconf.enable = true;
}
