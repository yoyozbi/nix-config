{ fetchurl
, makeDesktopItem
, appimageTools
}:
let
  pname = "kDrive";
  version = "3.5.8.20240227";
  name = "${pname}-${version}-amd64";

  src = fetchurl {
    url = "https://download.storage.infomaniak.com/drive/desktopclient/${name}.AppImage";
    sha256 = "v+Zw7R/JuwRCkidMb+hdmX9dau5aQhHIjcwgbCc5npQ=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 {
  inherit name version src pname;
  extraPkgs = pkgs:
    with pkgs; [
      libsecret
      libnotify
      fuse3
      libjpeg_original
      zstd
    ];
  
  extraInstallCommands = ''
    runHook preInstall
    mkdir -p "$out/share/applications"
    cp -r ${appimageContents}/usr/* "$out"
    chmod -R +rw $out/share
    chmod -R +x $out/bin

    runHook postInstall
  '';
}
