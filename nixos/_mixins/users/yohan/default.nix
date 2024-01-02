{ config, desktop, lib, pkgs, inputs, ...}:
let
	ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
	stable-packages = with pkgs; [
		kubectl
		kubectx
		envsubst
		kubernetes-helm
		minikube

	]  ++ lib.optionals (desktop != null)[
		appimage-run
		libreoffice
		owncloud-client
		firefox
		
		#Music
		tidal-hifi
		spotify

		# Discord
		discord

		# Other
		beekeeper-studio
		#obsidian
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

		# IDE
		#neovim
		#jetbrains-toolbox

		# C/C++
		# gcc
		# clang-tools
		# cmake
		# ninja
		# gnumake
		# unzip
		# wget

		# Rust
	#	rust
	#	rust-analyzer-unwrapped

		# Go
		# go
		# gopls
			

		# PHP
		# php82
		# php82Packages.composer
	];
	unstable-packages = with pkgs.unstable;[
		vivaldi
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
			packages = [ pkgs.home-manager ];
			shell = pkgs.zsh;
		};
	}
