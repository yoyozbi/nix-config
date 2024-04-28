_: {
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1FC5-9E05";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
