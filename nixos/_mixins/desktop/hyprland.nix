{ inputs
, pkgs
, username
, ...
}:
let
  stable-packages = with pkgs; [
    shikane
    wofi
    wlogout
    sway-audio-idle-inhibit
    swaybg
    gnome.nautilus
    darkman
    pulsemixer
    bluetuith
    kitty
    dunst
    pamixer
    python311
    python311Packages.requests
    grim
    slurp
    swappy
    networkmanagerapplet 
    gnome.seahorse
    libsForQt5.polkit-kde-agent
    imagemagick_light
  ];

  unstable-packages = with pkgs.unstable; [
    waybar
    cliphist
    hypridle
    hyprlock
  ];
in
{
  imports = [
    ../services/networkmanager.nix
    ../services/pipewire.nix
  ];
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    bash = {
      interactiveShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
           WLR_NO_HARDWARE_CURSORS=1 Hyprland #prevents cursor disappear when using Nvidia drivers
        fi
      '';
    };
    dconf.enable = true;
  };

  environment.systemPackages = stable-packages ++ unstable-packages;
  services = {
    greetd = {
	enable = true;
	settings = {
	  default_session = {
	    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
	    user = "${username}";
	  };
	};
    };
    gvfs.enable = true;
    gnome = {
      gnome-keyring.enable = true;	
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security = {
    pam.services.hyprlock = { };
    polkit.enable = true;
  };
}
