{kubenix, ...}:
{

	kubernetes.helm.releases.rancher = {
		chart = kubenix.lib.helm.fetch {
			repo = "https://releases.rancher.com/server-charts/latest";
			chart = "rancher";
			version = "2.8.2";
			sha256 = "";
		};
		values = {
			hostname = "rancher.yohanzbinden.ch";
			replicas = 1;
			tls = "external";
			letsEncrypt.ingress.class = "traefik";
			ingress = {
				enabled = true;
			};
		};
	};

}
