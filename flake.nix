{
  inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    lanzaboote.url = "github:nix-community/lanzaboote";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
		cachix-deploy.url = "github:cachix/cachix-deploy-flake";

		sops-nix.url = "github:Mic92/sops-nix";

		home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

	outputs = { self, nixpkgs, lanzaboote, home-manager, nixos-hardware, cachix-deploy, ...} @ inputs :
	let
		inherit (self) outputs;
		system = "x86_64-linux";

		pkgs = nixpkgs.legacyPackages.${system};
		 # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
		stateVersion = "23.11";
		cachix-deploy-lib = cachix-deploy.lib pkgs;
		libx = import ./lib { inherit inputs outputs stateVersion; };
	in
	{
		homeConfigurations = {
			"yohan@laptop-nix" = libx.mkHome { hostname = "laptop-nix"; username = "yohan"; desktop = "gnome"; };
		};
    nixosConfigurations = {
				"laptop-nix" = libx.mkHost { hostname = "laptop-nix"; username = "yohan"; desktop = "gnome"; };
				"tiny1" = libx.mkHost {hostname = "tiny1"; username = "yohan"; };
				"tiny2" = libx.mkHost {hostname = "tiny2"; username = "yohan"; };
   		};

		packages.${system}= with pkgs; {
			cachix-deploy-spec = cachix-deploy-lib.spec {
				agents = {
					"tiny1" = self.nixosConfigurations."tiny1".config.system.build.toplevel;
					"tiny2" = self.nixosConfigurations."tiny2".config.system.build.toplevel;
				};
			};
		};

		overlays = import ./overlays {inherit inputs; };
	};
}
