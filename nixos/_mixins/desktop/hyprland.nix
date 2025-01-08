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
    xwaylandvideobridge
    brightnessctl
  ];

  unstable-packages = with pkgs.unstable; [
    waybar
    cliphist
    hypridle
    hyprlock
    kitty
    ghostty
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
      #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    dconf.enable = true;
  };

  environment.systemPackages = stable-packages ++ unstable-packages;

  environment.variables = {
    NIXOS_OZONE_WL = 1; # Force chromium based app to use wayland
  };

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
