{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  libgcrypt,
  libGL,
  libgpg-error,
  libsecret,
  libxkbcommon,
  log4cplus,
  openssl_3_3,
  pkg-config,
  poco,
  libzip,
  extra-cmake-modules,
  libsysprof-capture,
  qt6,
  sentry-native,
  shared-mime-info,
  sqlite,
  vulkan-headers,
  xxHash,
  ninja,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "kDrive";
  version = "3.6.9b";

  src = fetchFromGitHub {
    owner = "infomaniak";
    repo = "desktop-kDrive";
    rev = version;
    sha256 = "TDitGJdXDQrBuEHupXLGcSgpIhPBvDphTthcq6ZC8LA=";
  };

  buildInputs = [
    cmake
    glib
    libgcrypt
    libGL
    libgpg-error
    libsecret
    libxkbcommon
    extra-cmake-modules
    libsysprof-capture
    libzip
    ninja
    # This is required because kdrive needs the log4cplusConfig.cmake file, which is only generated when built with cmake
    # Since log4cplus is built with make in nixpkgs, we rebuild it with cmake
    (log4cplus.overrideAttrs (_: {
      nativeBuildInputs = [ cmake ];

      # kDrive is using the unicode version of log4cplus
      cmakeFlags = [ "-DUNICODE=ON" ];

      # See this issue for why the patch is needed: https://github.com/NixOS/nixpkgs/issues/144170
      patches = [ ./log4cplus-CMakeLists.txt.patch ];
    }))
    openssl_3_3
    pkg-config
    poco
    qt6.qt5compat
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtwayland
    qt6.qtwebengine
    shared-mime-info
    sentry-native
    sqlite
    vulkan-headers
    xxHash
    zlib
  ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  cmakeFlags = [
    "-DKDRIVE_THEME_DIR=${src}/infomaniak"
    "-DQT_FEATURE_neon=OFF"
    "-DSYSCONF_INSTALL_DIR=etc"
    "-DBUILD_UNIT_TESTS=off"
    "-Wdev"
    "--debug-output"
    "--trace"
  ];

  installFlagsArray = [
    # Build fails without this variable
    "DESTDIR=$(out)"
    "CMAKE_INSTALL_PREFIX=$(out)"
    "CMAKE_PREFIX_PATH=$(out)"
  ];

  patches = [ ./kdrive-CMakeLists.txt.patch ];

  postInstall = ''
    # After build, there are binaries in the way that differ from the one generated by make install
    rm -rf $out/bin

    # Because DESTDIR is set to $out, built files end up in /nix/store/<hash>-kDrive-<version>/nix/store/<hash>-kDrive-<version>
    #mv $out$out/* $out
    rm -rf $out/nix

    # The binary fails to start if sync-exclude.lst is not located in the same directory
    mv $out/etc/kDrive/sync-exclude.lst $out/bin/sync-exclude.lst

    # We don’t need the libsentry and libxxhash which are generated by the install process
    rm -rf $out/etc
  '';

  meta = {
    description = "Desktop Syncing Client for kDrive";
    homepage = "https://github.com/infomaniak/desktop-kDrive";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib; [ maintainers.nicolas-goudry ];
    mainProgram = "kDrive";
  };
}
