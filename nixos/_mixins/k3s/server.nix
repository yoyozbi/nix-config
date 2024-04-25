{ config, ... }: 
let
  rancher = if config.networking.yoyozbi.currentHost.rancher then builtins.readFile ./rancher.yaml else "";
in {
  imports = [ ./. ];

  services.k3s = {
    role = "server";
    extraFlags = toString [
      "--node-external-ip=${config.networking.yoyozbi.currentHost.externalIp}"
      "--node-ip=${config.networking.yoyozbi.currentHost.internalIp}"
      "--advertise-address=${config.networking.yoyozbi.currentHost.internalIp}"
    ];
    clusterInit = true;
  };

  environment.etc."k3s.yaml".text = builtins.readFile ./default.yaml;
  environment.etc."rancher.yaml".text = rancher;

  # Link the file to k3s manifest directory
  system.activationScripts.k3s.text = ''
    mkdir -p /var/lib/rancher/k3s/server/manifests
    ln -sf /etc/k3s.yaml /var/lib/rancher/k3s/server/manifests/init.yaml

    if [ -s /etc/rancher.yaml ]; then
	ln -sf /etc/rancher.yaml /var/lib/rancher/k3s/server/manifests/rancher.yaml
    fi
  '';
}
