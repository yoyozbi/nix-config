{
  config,
  lib,
  ...
}:
{
  imports = [ ./. ];

  services.k3s = {
    enable = false; #Disable agents to remove k3s data
    role = "agent";
    extraFlags = toString [
      #"--node-external-ip=${config.networking.yoyozbi.currentHost.externalIp}"
      #"--node-ip=${config.networking.yoyozbi.currentHost.internalIp}" # Apparently this causes gateway errors when querying logs
    ];
    serverAddr = lib.mkDefault "https://${config.networking.yoyozbi.hosts.ocr1.internalIp}:6443";
    tokenFile = config.sops.secrets.k3s-server-token.path;
  };
}
