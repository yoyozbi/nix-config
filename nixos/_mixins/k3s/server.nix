{...}:
{
	imports = [ ./. ];
	sops.secrets.k3s-server-token.sopsFile = ./secrets.yml;

	services.k3s.role = "server";
	services.k3s.clusterInit = true;
}
