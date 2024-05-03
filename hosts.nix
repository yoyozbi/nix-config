/*
  based on https://github.com/TUM-DSE/doctor-cluster-config/blob/master/modules/hosts.nix
*/
{ lib
, config
, hostname
, desktop
, ...
}:
let
  hostOptions = with lib; {
    internalIp = mkOption {
      type = types.str;
      description = ''
        own internal ipv4 address
      '';
    };
    externalIp = mkOption {
      type = types.str;
      description = ''
        own external ipv4 address
      '';
    };

    mac = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        MAC address of the NIC port used as a gateway
      '';
    };
    rancher = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        If this is a k3s server specify if you want to install rancher or not
      '';
    };
  };
in
{
  options = with lib; {
    networking.yoyozbi.hosts = mkOption {
      type = with types; attrsOf (submodule [{ options = hostOptions; }]);
      description = "A host in the cluster";
    };
    networking.yoyozbi.currentHost = mkOption {
      type = with types; submodule [{ options = hostOptions; }];
      default = config.networking.yoyozbi.hosts.${hostname};
      description = "The host that is described by this configuration";
    };
  };
  config = {
    warnings =
      lib.optional
        (
          !(config.networking.yoyozbi.hosts ? ${hostname})
          && desktop == null # we dont care if it is not a server
        )
        "Please add network configuration for ${hostname}. None found in ${./hosts.nix}";

    networking.yoyozbi.hosts = {
      ocr1 = {
        internalIp = "10.0.0.93";
        externalIp = "144.24.253.246";
        rancher = true;
        mac = "02:00:17:00:a1:bb";
      };
      tiny1 = {
        internalIp = "10.0.0.127";
        externalIp = "152.67.67.49";
        mac = "02:00:17:18:84:90";
        rancher = false;
      };
      tiny2 = {
        internalIp = "10.0.0.84";
        externalIp = "140.238.223.226";
        mac = "02:00:17:00:b0:5f";
        rancher = false;
      };
      rp = {
        internalIp = "192.168.1.2";
        mac = "dc:a6:32:21:28:99";
        rancher = false;
        externalIp = "192.168.1.2";
      };
    };
  };
}
