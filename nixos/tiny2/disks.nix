_: {
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1835-FDD0";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
