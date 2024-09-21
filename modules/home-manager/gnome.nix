{ pkgs, lib, ... }:

{
  home-manager.users.nico = {
    dconf = {
      enable = true;
      settings."org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          dash-to-dock.extensionUuid
        ];
      };
    };
  };
}
