{inputs, config, lib,pkgs,  ...}:
let 
	configFile = builtins.readFile ./default.yaml;
in
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

	sops.secrets.cloudflared-token = {
		sopsFile = ./secrets.yml;
		path = "/etc/cloudflared-token";
	};

	# Write the default kubernetes config to a file under `/etc`
	/*environment.etc."kubenix.yaml".source = 
	(inputs.kubenix.evalModules.${builtins.currentSystem} {
		specialArgs = { 
			inherit inputs config lib;
		};
		module = {kubenix, inputs, config, lib, ...}: {
				imports = [ ./deployments ];
				kubenix.project = "default-k3s-config";
				kubernetes.version = "1.28";
		};

	}).config.kubernetes.resultYAML;*/


	# Link the file to k3s manifest directory
	system.activationScripts.k3s.text = ''
    echo ${configFile} > /var/lib/rancher/k3s/server/manifests/init.yaml
  '';

}
