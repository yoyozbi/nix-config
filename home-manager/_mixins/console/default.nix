{config, lib, pkgs, ...}: 
let 
	inherit (pkgs.stdenv) isDarwin isLinux;
in
{
	fonts.fontconfig.enable = true;
	home = {
		file = {
			"${config.xdg.configHome}/yazi/keymap.toml".text = builtins.readFile ./yazi-keymap.toml;
			"${config.xdg.configHome}/yazi/theme.toml".text = builtins.readFile ./yazi-theme.toml;

			"${config.xdg.configHome}/nvim" = {
				source = ./nvim-config;
				recursive = true;
			};
		};

		packages = with pkgs; [
			(nerdfonts.override { fonts = ["FiraCode" "SourceCodePro" "UbuntuMono"]; })
			fira
      fira-go
      ubuntu_font_family
      work-sans
      asciicam # Terminal webcam
      asciinema-agg # Convert asciinema to .gif
      asciinema # Terminal recorder
      bandwhich # Modern Unix `iftop`
      bmon # Modern Unix `iftop`
      breezy # Terminal bzr client
      butler # Terminal Itch.io API client
      chafa # Terminal image viewer
      chroma # Code syntax highlighter
      clinfo # Terminal OpenCL info
      cpufetch # Terminal CPU info
      croc # Terminal file transfer
      curlie # Terminal HTTP client
      dconf2nix # Nix code from Dconf files
      difftastic # Modern Unix `diff`
      distrobox
      dogdns # Modern Unix `dig`
      dotacat # Modern Unix lolcat
      dua # Modern Unix `du`
      duf # Modern Unix `df`
      du-dust # Modern Unix `du`
      editorconfig-core-c # EditorConfig Core
      entr # Modern Unix `watch`
      fastfetch # Modern Unix system info
      fd # Modern Unix `find`
      frogmouth # Terminal mardown viewer
      glow # Terminal Markdown renderer
      gping # Modern Unix `ping`
      h # Modern Unix autojump for git projects
      hexyl # Modern Unix `hexedit`
      hr # Terminal horizontal rule
      httpie # Terminal HTTP client
      hyperfine # Terminal benchmarking
      iperf3 # Terminal network benchmarking
      jpegoptim # Terminal JPEG optimizer
      jiq # Modern Unix `jq`
      lima-bin # Terminal VM manager
      mdp # Terminal Markdown presenter
      mtr # Modern Unix `traceroute`
      neo-cowsay # Terminal ASCII cows
      netdiscover # Modern Unix `arp`
      nixpkgs-review # Nix code review
			nix-prefetch-scripts # Nix code fetcher
      nurl # Nix URL fetcher
      nyancat # Terminal rainbow spewing feline
      onefetch # Terminal git project info
      optipng # Terminal PNG optimizer
      procs # Modern Unix `ps`
      quilt # Terminal patch manager
      rclone # Modern Unix `rsync`
      sd # Modern Unix `sed`
      speedtest-go # Terminal speedtest.net
      terminal-parrot # Terminal ASCII parrot
      tldr # Modern Unix `man`
      tokei # Modern Unix `wc` for code
      ueberzugpp # Terminal image viewer integration
      upterm # Terminal sharing
      wget2 # Terminal HTTP client
      wthrr # Modern Unix weather
      wormhole-william # Terminal file transfer
      yq-go # Terminal `jq` for YAML



			nodejs_20
		] ++ lib.optionals isLinux [
			figlet # Terminal ASCII banners
      iw # Terminal WiFi info
      libva-utils # Terminal VAAPI info
      lurk # Modern Unix `strace`
      python310Packages.gpustat # Terminal GPU info
      ramfetch # Terminal system info
      vdpauinfo # Terminal VDPAU info
      wavemon # Terminal WiFi monitor
      zsync # Terminal file sync; FTBFS on aarch64-darwin
		];
	};
	programs = {
	 bat = {
			enable = true;
			extraPackages = with pkgs.bat-extras; [
				batgrep
				batwatch
				prettybat
			];
			config = {
				style = "plain";
			};
		};

		bottom = {
			enable = true;
			settings = {
        colors = {
          high_battery_color = "green";
          medium_battery_color = "yellow";
          low_battery_color = "red";
        };
        disk_filter = {
          is_list_ignored = true;
          list = [ "/dev/loop" ];
          regex = true;
          case_sensitive = false;
          whole_word = false;
        };
        flags = {
          dot_marker = false;
          enable_gpu_memory = true;
          group_processes = true;
          hide_table_gap = true;
          mem_as_value = true;
          tree = true;
        };
      };
		};

		dircolors = {
			enable = true;
			enableBashIntegration = true;
			enableFishIntegration = true;
			enableZshIntegration = true;
		};

		direnv = {
			enable = true;
			enableBashIntegration = true;
			enableZshIntegration = true;
			nix-direnv = {
				enable = true;
			};
		};

		eza = {
			enable = true;
			enableAliases = true;
			extraOptions = [
				"--group-directories-first"
				"--header"
			];
			git = true;
			icons = true;
		};

		zsh = {
			enable = true;
			shellAliases = {
				build-home = "pushd $HOME/Zero/nix-config && home-manager build --flake $HOME/yohan/nix-config && popd";
				switch-home = "pushd $HOME/Zero/nix-config && home-manager switch -b backup --flake $HOME/yohan/nix-config && popd";
				#ll = "ls -l";
				update = "sudo nixos-rebuild switch";
				brg = "batgrep";
				cat = "bat --paging=never";
				dmesg = "dmesg --human --color=always";
				htop = "btm --basic --tree --hide_table_gap --dot_marker --mem_as_value";
				top = "btm --basic --tree --hide_table_gap --dot_marker --mem_as_value";
				ip = "ip --color --brief";
				less = "bat";
				more = "bat";
				checkip = "curl -s ifconfig.me/ip";
				tree = "eza --tree";
			};
			 oh-my-zsh = {
				enable = true;
				plugins = [ "git" "thefuck" ];
				theme = "robbyrussell";
			};
		};

		git = {
			enable = true;
			aliases = {
				fucked = "reset --hard";
				graph = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
			};
			extraConfig = {
				core = {
					pager = "bat";
				};
				push = {
					default = "matching";
				};
				pull = {
					rebase = false;
				};
				init = {
					defaultBranch = "main";
				};
			};
		};

		gpg.enable = true;
		home-manager.enable = true;
		ripgrep = {
			arguments = [
				"--colors=line:style:bold"
        "--max-columns-preview"
        "--smart-case"
			];
		};

		yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = false;
          show_symlink = true;
          sort_by = "natural";
          sort_dir_first = true;
          sort_sensitive = false;
          sort_reverse = false;
        };
      };
    };
		neovim = {
			enable = true;
		};
	};

	# Nicely reload system units when changing configs
	systemd.user.startServices = lib.mkIf isLinux "sd-switch";
	
	xdg = {
		enable = isLinux;
		userDirs = {
			enable = isLinux;
			createDirectories = lib.mkDefault true;
		};

		};
}
