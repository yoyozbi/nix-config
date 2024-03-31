_: {
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/83D1-6639";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
