{
  ...
}:
{
  imports = [
    ../../modules/home-manager
  ];

  home-manager = {
    enable = true;
    niri = {
      enable = true;
      calendar.enable = true;
      wlsunset = {
        enable = true;
        latitude = 52.42;
        longitude = 10.78;
      };
    };

    terminal.enable = true;
    zed.enable = true;
    zen.enable = true;
    opencode.enable = true;
    zathura.enable = true;
    direnv.enable = true;
  };
}
