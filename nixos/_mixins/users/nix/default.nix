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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0wY1HBFWJGgaoT0L23bQg3icnmyDBds12gc0iOzuDV yohan@laptop-nix"
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
