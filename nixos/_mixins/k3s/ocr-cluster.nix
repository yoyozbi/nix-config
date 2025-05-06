_: {
  sops.defaultSopsFile = ./ocr-secrets.yml;
  sops.secrets = {
    netdata-claim-token = {
      path = "/var/lib/netdata/cloud.d/token";
    };
    k3s-server-token = {};
  };
}
