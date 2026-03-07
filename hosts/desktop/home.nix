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

    firefox.enable = false;
    terminal.enable = true;
    yazi.enable = true;
    zathura.enable = true;
    direnv.enable = true;

    hyprland = {
      enable = true;
      displays = [
        {
          display = "DP-6";
          primary = true;
          resolution = "3840x2160";
          refreshRate = 240;
          scale = "2";
          vrr = true;
        }
      ];
    };
  };
}
