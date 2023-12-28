{
  inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    lanzaboote.url = "github:nix-community/lanzaboote";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
		home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

	outputs = { self, nixpkgs, lanzaboote, home-manager, nixos-hardware, ...} @ inputs :
	let
		inherit (self) outputs;
		 # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
		stateVersion = "23.11";
		libx = import ./lib { inherit inputs outputs stateVersion; };
	in
	{
		homeConfigurations = {
			"yohan@laptop-nix" = libx.mkHome { hostname = "laptop-nix"; username = "yohan"; desktop = "gnome"; };
		};
    nixosConfigurations = {
				"laptop-nix" = libx.mkHost { hostname = "laptop-nix"; username = "yohan"; desktop = "gnome"; };
   #    "laptop-nix" = nixpkgs.lib.nixosSystem {
   #      system = "x86_64-linux";
			#
   #      modules = [
   #        # This is not a complete NixOS configuration and you need to reference
   #        # your normal configuration here.
			#
   #        lanzaboote.nixosModules.lanzaboote
			# 		./configuration.nix
			# 		nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
			# 		home-manager.nixosModules.home-manager
			# 		{
			# 			home-manager.useGlobalPkgs = true;
			# 			home-manager.useUserPackages = true;
			# 			home-manager.users.yohan = import ./home-manager;
			# 		}
			# 	];
			# };
		};

		overlays = import ./overlays {inherit inputs; };
	};
}
