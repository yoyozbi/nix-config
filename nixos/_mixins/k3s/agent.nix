{ config
, lib
, ...
}: {
  imports = [ ./. ];

  services.k3s = {
    role = "agent";
    extraFlags = toString [
      "--node-external-ip=${config.networking.yoyozbi.currentHost.externalIp}"
      "--node-ip=${config.networking.yoyozbi.currentHost.internalIp}"
    ];
    serverAddr = lib.mkDefault "https://${config.networking.yoyozbi.hosts.ocr1.internalIp}:6443";
    tokenFile = config.sops.secrets.k3s-server-token.path;
  };
}
