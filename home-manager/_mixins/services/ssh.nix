_: {
  programs = {
    ssh = {
      enable = true;
      matchBlocks = {
        "gitlab-etu.ing.he-arc.ch" = {
          hostname = "gitlab-etu.ing.he-arc.ch";
          identityFile = "/home/yohan/.ssh/id_gitlab-etu";
        };

        "github.com" = {
          hostname = "github.com";
          identityFile = "/home/yohan/.ssh/id_github";
        };

        rp = {
          hostname = "192.168.1.2";
          user = "nix";
          identityFile = "/home/yohan/.ssh/id_github";
        };
        ocr1 = {
          hostname = "144.24.253.246";
          user = "nix";
          identityFile = "/home/yohan/.ssh/id_github";
        };

        tiny1 = {
          hostname = "152.67.67.49";
          user = "nix";
          identityFile = "/home/yohan/.ssh/id_github";
        };

        tiny2 = {
          hostname = "140.238.223.226";
          user = "nix";
          identityFile = "/home/yohan/.ssh/id_github";
        };
      };
    };
  };
}
