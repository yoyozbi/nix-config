{ config, ... }:
let
  rancher =
    if config.networking.yoyozbi.currentHost.rancher
    then builtins.readFile ./rancher.yaml
    else "";

		traefik-dashboard = if config.networking.yoyozbi.currentHost.traefik-dashboard != null && config.networking.yoyozbi.currentHost.traefik-dashboard.enabled 
		then builtins.replaceStrings ["<TRAEFIK-HOSTNAME>"] [config.networking.yoyozbi.currentHost.traefik-dashboard.dashboardUrl] (builtins.readFile ./traefik.yaml)
		else "";
in
{
  imports = [ ./. ];

  services.k3s = {
    role = "server";
    extraFlags = toString [
      "--node-external-ip=${config.networking.yoyozbi.currentHost.externalIp}"
      "--node-ip=${config.networking.yoyozbi.currentHost.internalIp}"
      "--advertise-address=${config.networking.yoyozbi.currentHost.internalIp}"
    ];
    tokenFile = config.sops.secrets.k3s-server-token.path;
    clusterInit = true;
  };

  environment.etc."k3s.yaml".text = builtins.readFile ./default.yaml;
  environment.etc."rancher.yaml".text = rancher;
	environment.etc."traefik-dashboard.yaml".text = traefik-dashboard;

  # Link the file to k3s manifest directory
  system.activationScripts.k3s.text = ''
       mkdir -p /var/lib/rancher/k3s/server/manifests
       ln -sf /etc/k3s.yaml /var/lib/rancher/k3s/server/manifests/init.yaml

       if [ -s /etc/rancher.yaml ]; then
    ln -sf /etc/rancher.yaml /var/lib/rancher/k3s/server/manifests/rancher.yaml
       fi

				if [ -s /etc/traefik-dashboard.yaml ]; then
					ln -sf /etc/traefik-dashboard.yaml /var/lib/rancher/k3s/server/manifests/traefik-dashboard.yaml
				fi
					
  '';
}
