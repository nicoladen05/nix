{
  lib,
  config,
  ...
}:

{
  options = {
    home-manager.zed.enable = lib.mkEnableOption "enable zed editor";
  };

  config = lib.mkIf config.home-manager.zed.enable {
    programs.zed-editor.enable = true;
  };
}
