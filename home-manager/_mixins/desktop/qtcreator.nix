{ pkgs, ... }:
{
  qt = {
    enable = true;
  };

  home.packages = with pkgs; [
    qtcreator
    qt6.full
    cmake
    ninja
    gcc
    gdb
  ];
}
