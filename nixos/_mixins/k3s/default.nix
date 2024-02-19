{config, pkgs, lib, ...}:
{
	networking.firewall = {
		allowedTCPPorts = [
			6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
			# 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    	# 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
			];

			allowedUDPPorts = [
     	8472 # k3s, flannel: required if using multi-node for inter-node networking
  		];
		};


		sops.secrets.k3s-server-token.sopsFile = ./secrets.yml;


		services = {
			k3s = {
				enable = true;
				extraFlags = toString [
					"--node-external-ip=${config.networking.yoyozbi.hosts.currentHost.externalIp}"
					"--node-ip=${config.networking.yoyozbi.hosts.currentHost.internalIp}"
					"--advertise-address=${config.networking.yoyozbi.hosts.currentHost.internalIp}"
				];
				tokenFile = lib.mkDefault config.sops.secrets.k3s-server-token.path;
			};	

			openiscsi = { # For longhorn
				enable = true;
				name = "hostname-initiatorhost";
			};
		};

		environment.systemPackages = [ 
		pkgs.nfs-utils
		pkgs.k3s
			(pkgs.writeShellScriptBin "k3s-reset-node" (builtins.readFile ./k3s-reset-node))
		];
}
