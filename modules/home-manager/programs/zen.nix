{
  lib,
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options = {
    home-manager.zen.enable = lib.mkEnableOption "zen browser";
  };

  config = lib.mkIf config.home-manager.zen.enable {

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };
  };
}
