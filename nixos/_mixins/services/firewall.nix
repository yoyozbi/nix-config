{ lib, hostname, ...}:
let 
	wireguard = {
		hosts = [
			"laptop-nix"
		];
	
		tcpPortRanges = [
			{from = 3000; to = 4000;}
		];
	};
in
{
	networking = {
		firewall = {
			enable = true;
			logReversePathDrops = true;
			allowedTCPPortRanges = [ ]
				++ lib.optionals (builtins.elem hostname wireguard.hosts) wireguard.tcpPortRanges;
		};
	};
}
