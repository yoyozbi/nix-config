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
		sops.secrets.cloudflared-token = {
			sopsFile = ./secrets.yml;
			path = "/etc/cloudflared-token";
		};


		services = {
			k3s = {
				enable = true;
				tokenFile = lib.mkDefault config.sops.secrets.k3s-server-token.path;
			};	

			openiscsi = { # For longhorn
				enable = true;
				name = "hostname-initiatorhost";
			};
		};

		environment.systemPackages = [ 
			pkgs.nfs-utils
			pkgs.openiscsi
			pkgs.k3s
			(pkgs.writeShellScriptBin "k3s-reset-node" (builtins.readFile ./k3s-reset-node))
		];
}
