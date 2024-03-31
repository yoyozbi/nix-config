{ fetchurl
, makeDesktopItem
, appimageTools
,
}:
let
  pname = "kDrive";
  version = "3.5.3.20231023";
  name = "${pname}-${version}-amd64";

  src = fetchurl {
    url = "https://download.storage.infomaniak.com/drive/desktopclient/${name}.AppImage";
    sha256 = "UGpPHzBwQ5jDi0805GE0ZVAjjQf5CCQsxgrrr6qnqZE=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    comment = "Infomaniak kDrive desktop client";
    desktopName = "kDrive";
    type = "Application";
    icon = pname;
    categories = [ "Office" ];
  };
in
appimageTools.wrapType2 {
  inherit name version src pname;
  extraPkgs = pkgs:
    with pkgs; [
      libsecret
      libnotify
    ];
  extraInstallCommands = ''
    runHook preInstall

    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor
    cp ${desktopItem}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
      cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/hicolor/
      chmod -R +w $out/share

    runHook postInstall
  '';
}
