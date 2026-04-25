{
  lib,
  config,
  ...
}:

{
  options = {
    home-manager.spotify-player.enable = lib.mkEnableOption "spotify player";
  };

  config = lib.mkIf config.home-manager.spotify-player.enable {
    programs.spotify-player = {
      enable = true;

      settings = {
        enable_notify = false;
      };

      keymaps = [
        {
          command = "SelectNextOrScrollDown";
          key_sequence = "n";
        }
        {
          command = "SelectPreviousOrScrollUp";
          key_sequence = "e";
        }
        {
          command = "NextTrack";
          key_sequence = "i";
        }
        {
          command = "PreviousTrack";
          key_sequence = "h";
        }
      ];
    };
  };
}
