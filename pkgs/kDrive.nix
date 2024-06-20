{ fetchFromGitHub
, makeDesktopItem
, stdenv
, pkgs
}:
let
  pname = "kDrive";
  version = "3.6.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
		owner = "infomaniak";
		repo = "desktop-kDrive";
		rev = "${version}";
    sha256 = "Aq7/cYIntVglfaAgKJsbfvTzwPcSWQkR4O0Sc+puhpw=";
  };

  
in
stdenv.mkDerivation rec {
	inherit pname version src;
	nativeBuildInputs = [ pkgs.kdePackages.wrapQtAppsHook pkgs.cmake pkgs.pkg-config ];
	buildInputs = with pkgs; [
		qt6.full
		qt6.qtbase
		poco
		libsecret
		sentry-native
		log4cplus
	];
	env = {
		log4cplus_DIR = "${pkgs.log4cplus}/lib";
	};
}
