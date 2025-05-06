{ pkgs, ... }:
{
  services = {
    netdata = {
      enable = true;
      package = pkgs.unstable.netdata;
      config = {
        global = {
          "memory mode" = "ram";
          "debug log" = "none";
          "access log" = "none";
          "error log" = "syslog";
        };
      };
      configDir = {
      };
    };
  };
  environment.systemPackages = [ pkgs.netdata ];
}
