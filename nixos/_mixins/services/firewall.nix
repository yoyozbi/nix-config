{ lib
, hostname
, ...
}:
let
  wireguard = {
    hosts = [
      "laptop-nix"
    ];

    tcpPortRanges = [
      {
        from = 3000;
        to = 4000;
      }
    ];
  };
  kdeconnect = {
    hosts = [
      "laptop-nix"
    ];

    tcpPortRanges = [
      {
        from = 1716;
        to = 1764;
      }
    ];
    udpPortRanges = [
      {
        from = 1716;
        to = 1764;
      }
    ];
  };
in
{
  networking = {
    firewall = {
      enable = true;
      logReversePathDrops = true;
      allowedTCPPortRanges =
        lib.optionals (builtins.elem hostname wireguard.hosts) wireguard.tcpPortRanges
        ++ lib.optionals (builtins.elem hostname kdeconnect.hosts) kdeconnect.tcpPortRanges;
      allowedUDPPortRanges =
        lib.optionals (builtins.elem hostname kdeconnect.hosts) kdeconnect.udpPortRanges;
    };
  };
}
