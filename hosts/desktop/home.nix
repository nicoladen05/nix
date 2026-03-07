{
  inputs,
  ...
}:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
    ../../modules/home-manager
  ];

  home-manager = {
    enable = true;
    niri = {
      enable = true;
      wlsunset = {
        enable = true;
        latitude = 52.42;
        longitude = 10.78;
      };
    };
    mako.enable = true;

    terminal.enable = true;
    zed.enable = true;
    zathura.enable = true;
    direnv.enable = true;
  };
}
