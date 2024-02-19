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

	sops.secrets.cloudflared-token.sopsFile = ./deployments/secrets.yml;

	# Write the default kubernetes config to a file under `/etc`
	environment.etc."kubenix.yaml".source = 
	(inputs.kubenix.evalModules.x86_64-linux {
		module = { self, kubenix, ...}:
		let
			inherit (self) config;
		in {
				imports = [
					./deployments
				];
		};
	}).config.kubernetes.resultYAML;

	# Link the file to k3s manifest directory
	system.activationScripts.kubenix.text = ''
    ln -sf /etc/kubenix.yaml /var/lib/rancher/k3s/server/manifests/kubenix.yaml
  '';

}
