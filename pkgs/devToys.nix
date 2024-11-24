{ fetchFromGitHub
, buildDotnetModule
, lib
, pkgs
, combinePackages
}:

buildDotnetModule rec {
  pname = "DevToys";
  version = "2.0.8.0";
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0_2xx;

  src = fetchFromGitHub {
    owner = "DevToys-app";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-moeSici1mb6u28a0IPB6jOpxvbNgGOSLlhrwKyn1wqI=";
  };

  nugetDeps = ./deps.nix;

  projectFile = "src/app/dev/platforms/desktop/DevToys.Linux/DevToys.Linux.csproj";
  buildInputs = [
    pkgs.mono
  ];

  meta = with lib; {
    homepage = "https://github.com/DevToys-app/DevToys";
    description = "A Swiss Army knife for developers.";
    license = licenses.mit;
  };
}

