_: {
  virtualisation = {
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
      guest.enable = true;
      guest.x11 = true;
    };
  };
}
