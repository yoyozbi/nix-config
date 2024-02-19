{config, ...}:
{
	imports = [ ./. ];
	sops.secrets.k3s-server-token.sopsFile = ./secrets.yml;
	services.k3s = {
		role = "server";
		extraFlags = toString [
			"--node-external-ip=${config.networking.yoyozbi.currentHost.externalIp}"
			"--node-ip=${config.networking.yoyozbi.currentHost.internalIp}"
			"--advertise-address=${config.networking.yoyozbi.currentHost.internalIp}"
		];
	};

}
