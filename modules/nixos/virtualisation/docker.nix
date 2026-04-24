{
  lib,
  config,
  ...
}:

{
  options = {
    programs.docker.enable = lib.mkEnableOption "enable docker";
  };

  config = lib.mkIf config.programs.docker.enable {
    virtualisation.docker.enable = true;
    users.users."${config.system.userName}".extraGroups = [ "docker" ];
  };
}
