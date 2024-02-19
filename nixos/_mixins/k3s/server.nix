{inputs, config, ...}:
{
	sops.secrets.k3s-server-token.sopsFile = ./secrets.yml;
	services.k3s = {
		role = "server";
		extraFlags = toString [
			"--node-external-ip=${config.networking.yoyozbi.currentHost.externalIp}"
			"--node-ip=${config.networking.yoyozbi.currentHost.internalIp}"
			"--advertise-address=${config.networking.yoyozbi.currentHost.internalIp}"
		];
	};

	# Write the default kubernetes config to a file under `/etc`
	environment.etc."kubenix.yaml".source = 
	(inputs.kubenix.evalModules.x86_64-linux {
		module = { kubenix, ...}: {
			imports = [
			./deployments/cloudflared.nix
			./deployments/rancher.nix
			];
		};
	}).config.kubernetes.resultYAML;

	# Link the file to k3s manifest directory
	system.activationScripts.kubenix.text = ''
    ln -sf /etc/kubenix.yaml /var/lib/rancher/k3s/server/manifests/kubenix.yaml
  '';

}
