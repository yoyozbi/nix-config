{...} : {
  imports = [
    ../services/networkmanager.nix
    ../services/pipewire.nix
  ];
  services= {
    desktopManager.plasma5.mobile.enable = true;
  };
}
