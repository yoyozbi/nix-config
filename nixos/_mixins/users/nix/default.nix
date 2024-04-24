{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  users.groups.nix = { };
  users.users.nix = {
    group = "nix";
    extraGroups = [
      "keys"
    ];
    hashedPassword = null;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILUhAz/A2G0feoUU1BvE0p01BBvJ7BV7cU7RmACrLp7Z yohan@laptop-nix"
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ "nix" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];
}
