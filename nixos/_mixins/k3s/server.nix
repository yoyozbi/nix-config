{ config, ... }: {
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

  # Link the file to k3s manifest directory
  system.activationScripts.k3s.text = ''
    ln -sf /etc/k3s.yaml /var/lib/rancher/k3s/server/manifests/init.yaml
  '';
}
