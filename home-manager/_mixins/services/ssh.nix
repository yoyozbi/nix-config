_:
{
	programs = {
		ssh = {
			enable = true;
			matchBlocks = {
				"gitlab-etu.ing.he-arc.ch" = {
					hostname = "gitlab-etu.ing.he-arc.ch";
					identityFile = "/home/yohan/.ssh/id_gitlab-etu";
				};

				"github.com" = {
					hostname = "github.com";
					identityFile = "/home/yohan/.ssh/id_github";
				};

				rp = {
					hostname = "192.168.1.2";
					user = "yohan";
					identityFile = "/home/yohan/.ssh/id_rp";
				};
				ocr1 = {
					hostname = "144.24.253.246";
					user = "ubuntu";
					identityFile = "/home/yohan/.ssh/id_github";
				};

				tiny1 = {
					hostname = "140.238.217.72";
					user ="nix";
					identityFile = "/home/yohan/.ssh/id_ed25519";
				};

				tiny2 = {
					hostname = "140.238.223.226";
					user = "nix";
					identityFile = "/home/yohan/.ssh/id_ed25519";
				};

				k0s1 = {
					hostname = "192.168.1.10";
					user = "core";
					identityFile = "/home/yohan/.ssh/id_k0s";
				};
				k0s2 = {
					hostname = "192.168.1.11";
					user = "core";
					identityFile = "/home/yohan/.ssh/id_k0s";
				};
				k0s3 = {
					hostname = "192.168.1.12";
					user = "core";
					identityFile = "/home/yohan/.ssh/id_k0s";
				};
			};
		};
	};
}
