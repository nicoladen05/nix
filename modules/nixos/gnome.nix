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
      options = "caps:swapescape"
    };
  };
}
