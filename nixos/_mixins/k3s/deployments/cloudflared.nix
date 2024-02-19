{inputs, config, lib, ...}
:
{
	imports = [./.];

	sops.secrets.cloudflared-token.sopsFile = ./secrets.yml;
	submodules.instances.kube-system = {
		submodule = "namespaced"; 

		args.kubernetes.resources = {
			secrets.cloudflared-secret.stringData = {
				token = "ref+file://${config.sops.secrets.cloudflared-token.path}";
			};

			deployments.cloudflared.spec = {
				replicas = 2;
				selector.matchLabels.app = "cloudflared";
				template = {
					metadata.labels.app = "cloudflared";
					containers.cloudflared = {
						image = "cloudflare/cloudflared:1498-a9aa48d7a1e5";
						imagePullPolicy = "IfNotPresent";
						command = ["cloudflared" "tunnel"];
						args = ["--no-autoupdate" "run" "--token" "$(TOKEN)"];
						resources = {
							limits = {
								cpu = "100m";
								memory = "100Mi";
							};
							requests = {
								cpu = "100m";
								memory = "100Mi";
							};
						};
						env.TOKEN = {
							valueFrom = {
								secretKeyRef = {
									key = "token";
									name = "cloudflared-secret";
								};
							};
						};
						restartPolicy = "always";
					};
				};
			};
		};
	};

}
