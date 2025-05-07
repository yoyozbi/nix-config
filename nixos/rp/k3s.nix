_: {
  sops.secrets.k3s-server-token.sopsFile = ./rp-sec.yml;
  sops.secrets.cloudflared-token = {
    sopsFile = ./rp-sec.yml;
  };

  imports = [
    ../_mixins/k3s/server.nix
  ];
}
