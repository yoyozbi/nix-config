{ config, desktop, lib, pkgs, inputs, ...}:
let
	ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
	stable-packages = with pkgs; [
		kubectl
		kubectx
		envsubst
		kubernetes-helm
		cifs-utils

	]  ++ lib.optionals (desktop != null)[
		appimage-run
		libreoffice
		owncloud-client
		distrobox
		tigervnc

		bottles
		lutris
		wine-wayland
		#winePackages.wayland
		winetricks
		samba
		
		minikube
		#Music
		tidal-hifi
		spotify
		stremio
		qbittorrent

		# Discord
		discord

		# Other
		beekeeper-studio
		obsidian
		structorizer
		vlc
		
		#Tex
		texstudio
		texlive.combined.scheme-full
		# Photos
		darktable
		digikam
		# Dev
		# tmux
		bruno
		python311
		python311Packages.jupyter
		python311Packages.notebook
		python311Packages.pip

		# IDE
		#neovim
		#jetbrains-toolbox

		# C/C++
		gcc
		clang-tools
		cmake
		ninja
		gnumake
		unzip
		wget
		jetbrains-toolbox

		# Rust
		rustup
		rustPackages.clippy
		rustfmt
	#	rust
	#	rust-analyzer-unwrapped

		# Go
		go
		gopls
			

		# PHP
		php82
		php82Packages.composer
	];
	unstable-packages = with pkgs.unstable;[
		
	] ++ lib.optionals (desktop != null) [
		floorp
		firefox
		microsoft-edge
		];
	in 
	{
		imports = [
			#../../../../home-manager
		]
			++ lib.optionals (desktop != null) [
			];

		environment.localBinInPath = true;
		environment.systemPackages = stable-packages ++ unstable-packages;

		nixpkgs.config.permittedInsecurePackages = [
        "electron-25.9.0"
    ];

		programs.zsh.enable = true;

		# Configure keymap in X11
  	services.xserver = {
    	layout = "ch";
    	xkbVariant = "fr";
  	};
  	# Configure console keymap
  	console.keyMap = "fr_CH";

		users.groups.yohan = {};

		users.users.yohan = {
			description = "Yohan Zbinden";
			isNormalUser = true;
			group = "yohan";
			extraGroups = [
				"audio"
				"input"
				"networkmanager"
				"kvm"
				"libvirtd"
				"users"
				"video"
				"wheel"
			] ++ ifExists [
				"docker"
				"lxd"
				"podman"
			];
			# mkpasswd -m sha-512
			hashedPassword = "$6$a.nRdlFB3YPvVgjX$iWBzmkH0zK/3n/yyEl2Fuwp1G4ayzr5zG0Un7z4hCvWoKctMZirMKWMcwPBgqRylhgnI.gKLhg5xvwqRuipqZ.";
    	openssh.authorizedKeys.keys = [
      	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0wY1HBFWJGgaoT0L23bQg3icnmyDBds12gc0iOzuDV yohan@laptop-nix"
    	];

			packages = [ pkgs.home-manager ];
			shell = pkgs.zsh;
		};
	}
