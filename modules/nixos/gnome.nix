{pkgs, lib, ...}:

{
  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome.enable = true;

    xkb = {
      layout = "us";
      variant = "colemak";
      options = "caps:swapescape";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.xwayland.enable = true;

}
