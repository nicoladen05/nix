{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.home-manager.niri.wlsunset;
  outputArgs = lib.concatMapStringsSep " " (output: "-o ${lib.escapeShellArg output}") cfg.outputs;
  execStart =
    "${pkgs.wlsunset}/bin/wlsunset"
    + " -l ${toString cfg.latitude}"
    + " -L ${toString cfg.longitude}"
    + " -T ${toString cfg.dayTemperature}"
    + " -t ${toString cfg.nightTemperature}"
    + " -d ${toString cfg.transitionDuration}"
    + " -g ${toString cfg.gamma}"
    + lib.optionalString (cfg.outputs != [ ]) " ${outputArgs}";
in
{
  options.home-manager.niri.wlsunset = {
    enable = lib.mkEnableOption "enable wlsunset for niri";

    latitude = lib.mkOption {
      type = lib.types.nullOr lib.types.float;
      default = null;
      example = 52.42;
      description = "Latitude used by wlsunset to calculate sunrise and sunset times.";
    };

    longitude = lib.mkOption {
      type = lib.types.nullOr lib.types.float;
      default = null;
      example = 10.78;
      description = "Longitude used by wlsunset to calculate sunrise and sunset times.";
    };

    dayTemperature = lib.mkOption {
      type = lib.types.int;
      default = 6500;
      description = "Daytime color temperature in Kelvin.";
    };

    nightTemperature = lib.mkOption {
      type = lib.types.int;
      default = 3400;
      description = "Nighttime color temperature in Kelvin.";
    };

    transitionDuration = lib.mkOption {
      type = lib.types.int;
      default = 5400;
      description = "Transition duration in seconds between day and night temperatures.";
    };

    gamma = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "Gamma correction value passed to wlsunset.";
    };

    outputs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "DP-6" ];
      description = "Optional list of outputs to apply red light mode to. Empty means all outputs.";
    };
  };

  config = lib.mkIf (config.home-manager.niri.enable && cfg.enable) {
    assertions = [
      {
        assertion = cfg.latitude != null;
        message = "home-manager.niri.wlsunset.latitude must be set when home-manager.niri.wlsunset.enable is true.";
      }
      {
        assertion = cfg.longitude != null;
        message = "home-manager.niri.wlsunset.longitude must be set when home-manager.niri.wlsunset.enable is true.";
      }
    ];

    home.packages = [
      pkgs.wlsunset
    ];

    systemd.user.services.wlsunset = {
      Unit = {
        Description = "wlsunset color temperature daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = execStart;
        Restart = "always";
        RestartSec = 3;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
