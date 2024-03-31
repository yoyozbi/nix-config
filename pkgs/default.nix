# Custom packages, that can be defined similarly to ones from nixpkgs
# Build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{ pkgs ? (import ../nixpkgs.nix) { } }: {
  #distrobox = pkgs.callPackage ./distrobox.nix { };
  kDrive = pkgs.callPackage ./kDrive.nix { };
  sddm-themes = pkgs.callPackage ./sddm-themes.nix { };
  eclipse202306 = pkgs.callPackage ./eclipse-202306 { };
}
