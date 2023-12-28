# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib,  ... }: let
#   flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
# 	openconnectOverlay = import "${builtins.fetchTarball https://github.com/vlaci/openconnect-sso/archive/master.tar.gz}/overlay.nix";
# 	
#   hyprland-flake = (import flake-compat {
#     src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
#   }).defaultNix;
# # Rustup toolchain
#   rust-overlay = builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
#
#   pkgs = import <nixpkgs> {
#     overlays = [
# 		(self: super: {
#
# 			 waybar = (super.waybar.override {
# 			 	# catch2 = super.catch2_3;
# 				swaySupport = false;
# 			 }).overrideAttrs (oldAttrs: {
# 				src = super.fetchFromGitHub {
# 					owner = "Alexays";
# 					repo = "Waybar";
# 					rev = "0.9.22";
# 					sha256 = "sha256-9LJDA+zrHF9Mn8+W9iUw50LvO+xdT7/l80KdltPrnDo=";
#     		};
# 				mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true" "-Dcava=disabled"];
# 				# patches = (super.patches or []) ++ [
# 				# 	(pkgs.fetchpatch {
# 				# 		name = "fix waybar hyprctl";
# 				# 		url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
# 				# 		sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
# 				# 	})
# 				# ];
# 			});
#
#
# 			godot_4 = super.godot_4.overrideAttrs (oldAttrs:  {
# 				version = "4.1.2-stable";
# 				src = super.fetchFromGitHub {
# 					owner = "godotengine";
# 					repo = "godot";
# 					rev = super.godot_4.version;
# 					hash = "sha256-kFIpY8kHa8ds/JgYWcUMB4RhwcJDebfeWFnI3BkFWiI=";
# 				};
# 			});
#
# 			# obsidian = super.obsidian.overrideAttrs (oldAttrs: {
#   	# 		version = "1.4.16";
#   	# 		src = super.fetchurl {
# 			# 		url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/obsidian-1.4.16.tar.gz";
# 			# 		sha256 = "sha256-PBKLGs3MZyarSMiWnjqY7d9bQrKu2uLAvLUufpHLxcw=";
# 			# 	};
# 			#
# 			# 	icon = super.fetchurl {
# 			# 		url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/2023_Obsidian_logo.svg/512px-2023_Obsidian_logo.svg.png";
# 			# 		sha256 = "bc36b1a71f67932ee09d2b90b3c6329e1edad5c7b836a9c0dce7e60cd1297969";
# 			# 	};
# 			#
# 			#
# 			# });
# 			
# 			# openconnect = super.openconnect.overrideAttrs (oldAttrs: {
# 			# 	version = "9.12";
# 			# 	src = super.fetchurl {
# 			# 		url = "ftp://ftp.infradead.org/pub/openconnect/openconnect-9.12.tar.gz";
# 			# 		sha256 = "sha256-or7c46pN/nXjbkB+SOjovJHUbe9TNayVZPv5G9SyQT4=";
# 			# 	};
# 			# });
# 		# 	networkmanager-openconnect = (super.networkmanager-openconnect.override {
# 		# 		withGnome = false;
# 		#
# 		# 	}).overrideAttrs (oldAttrs: {
# 		# 		version = "1.2.10";
# 		# 		src = super.fetchurl {
# 		# 				url = "mirror://gnome/sources/NetworkManager-openconnect/1.2/${oldAttrs.pname}-1.2.10.tar.xz";
# 		# 				sha256 = "hEtr9k7K25e0pox3bbiapebuflm9JLAYAihAaGMTZGQ=";
# 		# 		};
# 		#
# 		# 		buildInputs = oldAttrs.buildInputs ++ [super.webkitgtk_4_1];
# 		#
# 		# 		configureFlags = [
# 		# 			"--with-gnome=no"
# 		# 			"--with-gtk4=no"
# 		# 			"--enable-absolute-paths"
# 		# 			];
# 		# 		});
# 		})
# 		(import rust-overlay)
# 		openconnectOverlay
# 		];
#   };
#   toolchain = pkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
			#./gpupasstrough.nix
    ];
		
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
	#boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
	#boot.loader.systemd-boot.configurationLimit = 3;
	boot.lanzaboote = {
		enable = true;
		pkiBundle = "/etc/secureboot";
	};
  #boot.initrd.systemd.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.resumeDevice = "/dev/disk/by-uuid/1a8f4d0f-ff23-4c86-9f65-de2388610e00";

  # Enable swap on luks
  boot.initrd.luks.devices."luks-7efb93f8-93b9-40f2-b150-4ad3e86f8b6d".device = "/dev/disk/by-uuid/7efb93f8-93b9-40f2-b150-4ad3e86f8b6d";
  boot.initrd.luks.devices."luks-7efb93f8-93b9-40f2-b150-4ad3e86f8b6d".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "laptop-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
	# services.xserver.displayManager.sddm = {
	# 	enable = true;
	# 	theme = "sugar-dark";
	# };
  services.xserver.desktopManager.gnome.enable = true;

  # programs.hyprland = {
  #   enable = true;
  #   package = hyprland-flake.packages.${pkgs.system}.hyprland;
		# xwayland = {
  #       enable = true;
  #     };
  # }; 

	#programs.dconf.enable = true;
  # Enable gnome-keyring
  services.gnome.gnome-keyring.enable = true;

	services.fwupd.enable = true;
	services.hardware.bolt.enable = true;


	# specialisation."VFIO".configuration = {
 #  	system.nixos.tags = [ "with-vfio" ];
 #  	vfio.enable = true;
	# };




 #  programs.regreet.enable = true;
	# services.greetd = {
	# 	enable = true;
	# 	settings = {
	# 		initial_session = {
	# 			user = "yohan";
	# 			command = "$SHELL -l";
	# 		};
	# 	};
	# };
	#
	# programs.bash = {
	# 	interactiveShellInit = ''
	# 		 if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
 #           WLR_NO_HARDWARE_CURSORS=1 Hyprland #prevents cursor disappear when using Nvidia drivers
 #        fi
	# 	'';
	# };

	# Enable Hyprland
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };


	# xdg = {
 #    autostart.enable = true;
 #    portal = {
 #      enable = true;
 #      extraPortals = [
 #        pkgs.xdg-desktop-portal
 #        pkgs.xdg-desktop-portal-hyprland
 #      ];
	# 		wlr.enable = true;
 #    };
 #  };

	hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
				intel-media-driver
				vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      setLdLibraryPath = true;
    };
  };

  # Security
  security = {
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "ch";
    xkbVariant = "fr";
  };
  # Configure console keymap
  console.keyMap = "fr_CH";

  # Enable CUPS to print documents.
  services.printing.enable = true;

	# Enable bluetooth
	hardware.bluetooth.enable = true;
	# Headset buttons support
	systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
	};

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = false;
  services.xserver.synaptics.enable = true;

	nixpkgs.config.permittedInsecurePackages = [
     "teams-1.5.00.23861"
     "electron-25.9.0"
		 "electron_24"
  ];

  # Allow certain unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
     "teams"
		 "Oracle_VM_VirtualBox_Extension_Pack-7.0.10.vbox-extpack"
	];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yohan = {
    isNormalUser = true;
    description = "yohan";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" "libvirtd" ];
    packages = with pkgs; [
			libreoffice
			# Kubernetes
			kubectl
			kubectx
			envsubst
			kubernetes-helm
			minikube
			qbittorrent
			#openconnect-sso
      # Browsing / mail
      firefox
			# Music
			tidal-hifi
			spotify
      # Social
			discord
      # Gnome
      gnome.gnome-tweaks
			evince
			baobab
			gnome.gnome-keyring
			direnv
      # TUIs
      pulsemixer
      pamixer
      bluetuith
      # Other
			beekeeper-studio
			obsidian
      structorizer
			vlc
      stremio
      obs-studio
			distrobox
			# Latex
			texstudio
			texlive.combined.scheme-full
   #    (pkgs.appimageTools.wrapType2 {
   #  		name = "kDrive";
   #      src = fetchurl {
			# 		url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-3.5.5.20231213-amd64.AppImage";
			# 		sha256 = "DWnh2f5ZKq+znmgpxn84LG9sZl3FdDOxgJq+/06S4Xo=";
	  #    	};
			# 	extraPkgs = pkgs: with pkgs; [
			# 		libsecret
			# 		libgnome-keyring
			# 		libnotify
			# 	];
   #    })
			# (writeTextDir "share/applications/kDrive.desktop" ''
			# 	[Desktop Entry]
			# 	Version=1.0
			# 	Type=Application
			# 	Name=kDrive
			# 	Exec=kDrive
			# '')
			owncloud-client
			#(callPackage ./pkgs/kDrive.nix {})
			# Photos
			darktable
			digikam
      appimage-run
      # Development
      tmux
      git
			lazygit
			ripgrep
		  insomnia	
			# IDE
      neovim
      jetbrains-toolbox
			# Vscode
			vscode
			vscode-extensions.bradlc.vscode-tailwindcss
			vscode-extensions.eamodio.gitlens
			vscode-extensions.ms-azuretools.vscode-docker
			vscode-extensions.ms-vscode-remote.remote-containers
			vscode-extensions.github.copilot
			vscode-extensions.github.copilot-chat
			vscode-extensions.tamasfe.even-better-toml
			vscode-extensions.ms-vsliveshare.vsliveshare
			vscode-extensions.christian-kohler.path-intellisense
			vscode-extensions.bmewburn.vscode-intelephense-client
			vscode-extensions.devsense.profiler-php-vscode
			vscode-extensions.esbenp.prettier-vscode
			vscode-extensions.rust-lang.rust-analyzer
			vscode-extensions.bradlc.vscode-tailwindcss
			vscode-extensions.vscodevim.vim
			vscode-extensions.vscode-icons-team.vscode-icons



			gnomeExtensions.color-picker
			gnomeExtensions.hibernate-status-button
      # C/C++
      gcc
      clang-tools
      cmake
			ninja
      gnumake
      unzip
			#qtcreator-qt6
			#gdb
			#godot_4
			wget
      # Rust
      #toolchain
			rustup
      rust-analyzer-unwrapped
			# Go
			go
			gopls
			# Php
			php82
			php82Packages.composer
			# Other neovim required package
			luajitPackages.luarocks
			lua-language-server
			julia
      # Nodejs global packages
      pkgs.nodePackages."prettier"
      pkgs.nodePackages."eslint"
      #pkgs.nodePackages."@typescript-eslint/parser"
      #pkgs.nodePackages."vue-eslint-parser"
      pkgs.nodePackages."typescript-language-server"
      pkgs.nodePackages."@tailwindcss/language-server"
      pkgs.nodePackages."typescript"
      pkgs.nodePackages."vercel"
      pkgs.nodePackages."yaml-language-server"
      pkgs.nodePackages."intelephense"
      pkgs.nodePackages."dockerfile-language-server-nodejs"
    ];
  };
	# home-manager.users.yohan = { pkgs, ... }: {
	# 	home.packages = with pkgs; [
	# 		dconf
	# 	];	
	#
	# 	dconf = {
	# 		enable = true;
	# 		settings = {
	# 			"org/gnome/desktop/interface" = {
	# 				color-scheme = "prefer-dark";
	# 			};
	# 		};
	# 	};
	#
	# 	gtk = {
	# 		enable = true;
	# 		theme = {
	# 				name = "Adwaita-dark";
	# 				package = pkgs.orchis-theme;
	# 			};
	# 		iconTheme = {
	# 			name = "Adwaita";
	# 			package = pkgs.gnome.adwaita-icon-theme;
	# 		};
	#
	# 		# cursorTheme = {
	# 		# 	name =" Adwaita";
	# 		# 	package = pkgs.gnome.adwaita-icon-theme;
	# 		# };
	#
	# 	};
	# 	xdg.mimeApps.defaultApplications = {
	# 		"application/pdf" = ["org.gnome.Evince.desktop"];
	# 	};
	#
	# 	home.stateVersion = "23.11";
	# };

  environment.sessionVariables = rec {
		# TERMINAL                    = "kitty";
		# EDITOR                      = "nvim";
		# BROWSER                     = "firefox";
		# __GL_VRR_ALLOWED            = "1";
		 # WLR_NO_HARDWARE_CURSORS    = "1";
    # WLR_RENDERER_ALLOW_SOFTWARE = "1";
    # CLUTTER_BACKEND             = "wayland";
    # WLR_RENDERER                = "vulkan";

    #XDG_CURRENT_DESKTOP = "Hyprland";
    #XDG_SESSION_DESKTOP = "Hyprland";
    # XDG_SESSION_TYPE    = "wayland";

    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";

    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH = [ 
      "${XDG_BIN_HOME}"
    ];

    #RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
  };
  #
  # Allow unfree packages
  #nixpkgs.config.allowUnfree = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
  	(nerdfonts.override {fonts = [ "JetBrainsMono" "FiraCode" ]; })
    ];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
     neovim
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
#		(callPackage ./pkgs/openconnect {})
		# openconnect_openssl
		#(callPackage ./pkgs/openconnect {})
		lxappearance
		sbctl
		firmware-updater
		libnotify
		xdg-desktop-portal-hyprland
		xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
		qt6.full
    adwaita-qt
    adwaita-qt6
		hyprland-protocols
		# Virtualisation
		docker-compose
		# Hyprland
		swaybg
		swayidle
		#(callPackage ./pkgs/swayAudio {})
		wofi
		grim
		slurp
		swappy
		waybar
		shikane
		swaylock-effects
		wlogout
		dunst
		alacritty
		kitty
		cifs-utils
		keyutils
		tpm2-tss
		# Dev
		(python311.withPackages(ps: with ps; [pandas requests ipykernel pip]))
		nodejs_18
		bun
		jdk17
		virt-manager
		libargon2
  ]) ++ (with pkgs.gnome; [
		nautilus
		zenity
		gedit
		seahorse
		eog
		sushi
	]) ++ (let themes = pkgs.callPackage ./pkgs/sddm-themes.nix {}; in [
		themes.sddm-sugar-dark
	]);

	# Garbage collector
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};

	nixpkgs.config.allowUnfree = true;

	virtualisation = {

	 virtualbox = {
		host = {
			enable = true;
	#		enableExtensionPack = true;
		};
	 };

	 libvirtd = {
			enable = true;
	 };

	 docker = {
			enable = true;
		};
	};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
	# networking.firewall.checkReversePath = false;
	networking.firewall = {
   # if packets are still dropped, they will show up in dmesg
   logReversePathDrops = true;
	 allowedTCPPortRanges = [
		{from = 3000; to = 4000;}
	 ];
	 checkReversePath = false;
   # wireguard trips rpfilter up
   # extraCommands = ''
   #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
   #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
   # '';
   # extraStopCommands = ''
   #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
   #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
   # '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
