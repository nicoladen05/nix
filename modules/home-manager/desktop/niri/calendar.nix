{
  lib,
  config,
  osConfig,
  ...
}:

let
  cfg = config.home-manager.niri.calendar;
  googleClientIdPath = osConfig.sops.secrets."google/calendar/client_id".path;
  googleClientSecretPath = osConfig.sops.secrets."google/calendar/client_secret".path;
  calendarBasePath = "${config.xdg.dataHome}/calendars";
  vdirsyncerDataPath = "${config.xdg.dataHome}/vdirsyncer";
in
{
  options.home-manager.niri.calendar = {
    enable = lib.mkEnableOption "enable khal and vdirsyncer for Google Calendar";
  };

  config = lib.mkIf (config.home-manager.niri.enable && cfg.enable) {
    accounts.calendar.basePath = calendarBasePath;

    accounts.calendar.accounts.google = {
      khal = {
        enable = true;
        type = "discover";
        color = "light blue";
      };

      local.type = "filesystem";

      remote.type = "google_calendar";

      vdirsyncer = {
        enable = true;
        tokenFile = "${vdirsyncerDataPath}/google-calendar-token";
        collections = [ "from a" ];
        conflictResolution = "remote wins";
        clientIdCommand = [
          "cat"
          googleClientIdPath
        ];
        clientSecretCommand = [
          "cat"
          googleClientSecretPath
        ];
      };
    };

    programs.vdirsyncer = {
      enable = true;
      statusPath = "${vdirsyncerDataPath}/status";
    };

    programs.khal = {
      enable = true;
      locale = {
        timeformat = "%H:%M";
        dateformat = "%Y-%m-%d";
        longdateformat = "%Y-%m-%d";
        datetimeformat = "%Y-%m-%d %H:%M";
        longdatetimeformat = "%Y-%m-%d %H:%M";
        default_timezone = osConfig.time.timeZone;
        local_timezone = osConfig.time.timeZone;
      };

      settings = {
        default = {
          timedelta = "30d";
        };
        view = {
          dynamic_days = true;
        };
      };
    };

    services.vdirsyncer = {
      enable = true;
      frequency = "*:0/15";
    };
  };
}
