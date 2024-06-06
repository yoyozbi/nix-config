# This file defines overlays
{ inputs,  ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: _prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
		neovim = _prev.neovim.overrideAttrs (oldAttrs: rec {
			version = "0.10.0";
			src = _prev.fetchFromGitHub {
				owner = "neovim";
				repo = "neovim";
				rev = "v0.10.0";
				sha256 = "FCOipXHkAbkuFw9JjEpOIJ8BkyMkjkI0Dp+SzZ4yZlw=";
			};
		});
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
