_: {
  sops.secrets.k3s-server-token.sopsFile = ./ocr-secrets.yml;
  sops.secrets.cloudflared-token = {
    sopsFile = ./ocr-secrets.yml;
    path = "/etc/cloudflared-token";
  };
}
