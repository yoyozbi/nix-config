{inputs, lib, ...}:
{
	imports =  [ 
						inputs.kubenix.modules.k8s
						inputs.kubenix.modules.helm
						inputs.kubenis.modules.submodule
					 ];

	submodules.imports = [
		./_mixins/namespaced.nix
	];
	kubernetes.version = "1.28";
}
