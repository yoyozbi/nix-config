{kubenix, lib, ...}:
{
	imports =  [ 
						kubenix.modules.k8s
						kubenix.modules.helm
						kubenix.modules.submodule

						./cloudflared.nix
						./rancher.nix
					 ];

	submodules.imports = [
		./_mixins/namespaced.nix
	];
	kubernetes.version = "1.28";
}
