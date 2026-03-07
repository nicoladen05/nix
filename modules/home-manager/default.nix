{
  userName,
  lib,
  config,
  ...
}:

{
  imports = [
    ./terminal
    ./desktop
    ./firefox.nix
    ./zed.nix
  ];

  options = {
    home-manager.enable = lib.mkEnableOption "Enable home-manager";

    git.userName = lib.mkOption {
      type = lib.types.str;
      default = "nicoladen05";
      description = "The name to use for git commits";
    };
    git.userEmail = lib.mkOption {
      type = lib.types.str;
      default = "nicolashartmanntaba@gmail.com";
      description = "The email to use for git commits";
    };
  };

  config = lib.mkIf config.home-manager.enable {
    programs.home-manager.enable = true;

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "${config.git.userName}";
          email = "${config.git.userEmail}";
          signingkey = "~/.ssh/id_ed25519.pub";
        };

        gpg.format = "ssh";
        commit.gpgsign = true;

        init.defaultBranch = "main";
        pull.rebase = true;

        alias = {
          lg = "log --graph --oneline --decorate --all";
          lga = "log --graph --pretty=format:'%C(auto)%h%d %s %C(black)%C(bold)%cr'";
          c = "commit -m";
          a = "add -A";
          st = "status -sb";
          ca = "commit --amend --no-edit";
          rbi = "rebase --interactive";
          rba = "rebase --abort";
          rbc = "rebase --continue";
        };
      };
    };

    home.username = "${userName}";
    home.homeDirectory = "/home/${userName}";

    home.stateVersion = "24.05"; # Please read the comment before changing.
  };
}
