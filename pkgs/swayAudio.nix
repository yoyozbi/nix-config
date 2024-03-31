{ stdenv
, lib
, fetchFromGitHub
, wayland-protocols
, ninja
, meson
, cmake
, pipewire
, wayland
, wireplumber
, pkg-config
, libpulseaudio
,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "SwayAudioIdleInhibit";
  version = "c850bc4812216d03e05083c69aa05326a7fab9c7";
  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = finalAttrs.version;
    hash = "sha256-XUUUUeaXO7GApwe5vA/zxBrR1iCKvkQ/PMGelNXapbA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
  ];

  buildInputs = [
    wayland
    pipewire
    wireplumber
    wayland-protocols
    libpulseaudio
  ];

  meta = {
    homepage = "https://github.com/ErikReider/SwayAudioIdleInhibit";
    mainProgram = "sway-audio-idle-inhibit";
    changlelog = "https://github.com/ErikReider/SwayAudioIdleInhibit/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
  };
})
