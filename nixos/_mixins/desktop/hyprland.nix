{ inputs
, pkgs
, username
, ...
}:
let
  stable-packages = with pkgs; [
    shikane
    waybar
    wofi
    wlogout
    sway-audio-idle-inhibit
    swaybg
    swayidle
    gnome.nautilus
    darkman
    pulsemixer
    bluetuith
    kitty
    dunst
    pamixer
    swaylock-effects
  ];

  unstable-packages = with pkgs.unstable; [
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
    regreet.enable = true;
  };

  environment.systemPackages = stable-packages ++ unstable-packages;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "${username}";
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security.pam.services.swaylock = { };
}
