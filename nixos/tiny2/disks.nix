_: {
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1AAC-ED53";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
