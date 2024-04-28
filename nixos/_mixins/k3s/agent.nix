{ config
, lib
, ...
}: {
  imports = [ ./. ];

  services.k3s = {
    role = "agent";
    serverAddr = lib.mkDefault "https://${config.networking.yoyozbi.hosts.ocr1.internalIp}:6443";
    tokenFile = config.sops.secrets.k3s-server-token.path;
  };
}
