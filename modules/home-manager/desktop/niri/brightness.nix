{
  lib,
  pkgs,
  config,
  ...
}:

let
  niriDdcBrightness = pkgs.writeShellScriptBin "niri-ddc-brightness" ''
    #!/usr/bin/env bash

    set -euo pipefail

    action="''${1:-}"
    target_display=1
    cache_dir="''${XDG_RUNTIME_DIR:-/tmp}"
    cache_file="$cache_dir/niri-ddc-brightness-bus"

    get_cached_bus() {
      if [[ -r "$cache_file" ]]; then
        local cached_bus
        read -r cached_bus < "$cache_file"
        if [[ "$cached_bus" =~ ^[0-9]+$ ]] && [[ -e "/dev/i2c-$cached_bus" ]]; then
          echo "$cached_bus"
          return 0
        fi
      fi

      return 1
    }

    resolve_bus_for_display() {
      local bus
      bus="$(${pkgs.ddcutil}/bin/ddcutil --terse detect 2>/dev/null | ${pkgs.gawk}/bin/awk -v target="$target_display" '
        $1 == "Display" {
          in_display = ($2 == target)
          next
        }
        in_display && $1 == "I2C" && $2 == "bus:" {
          sub(".*/i2c-", "", $3)
          print $3
          exit
        }
      ')"

      if [[ ! "$bus" =~ ^[0-9]+$ ]]; then
        bus="$(${pkgs.ddcutil}/bin/ddcutil detect 2>/dev/null | ${pkgs.gawk}/bin/awk -v target="$target_display" '
          $1 == "Display" {
            in_display = ($2 == target)
            next
          }
          in_display && $1 == "I2C" && $2 == "bus:" {
            sub(".*/i2c-", "", $3)
            print $3
            exit
          }
        ')"
      fi

      if [[ -n "$bus" ]]; then
        mkdir -p "$cache_dir"
        printf '%s\n' "$bus" > "$cache_file"
        echo "$bus"
        return 0
      fi

      return 1
    }

    resolve_bus() {
      get_cached_bus || resolve_bus_for_display
    }

    get_brightness_values_from_bus() {
      local bus="$1"
      local output
      output="$(${pkgs.ddcutil}/bin/ddcutil --bus "$bus" getvcp 10 2>/dev/null)"

      if [[ "$output" =~ current[[:space:]]value[[:space:]]=[[:space:]]*([0-9]+),[[:space:]]max[[:space:]]value[[:space:]]=[[:space:]]*([0-9]+) ]]; then
        echo "''${BASH_REMATCH[1]} ''${BASH_REMATCH[2]}"
        return 0
      fi

      return 1
    }

    set_brightness_from_bus() {
      local bus="$1"
      local value="$2"
      ${pkgs.ddcutil}/bin/ddcutil --bus "$bus" --noverify setvcp 10 "$value" >/dev/null 2>&1
    }

    notify_error() {
      ${pkgs.libnotify}/bin/notify-send -u normal "Brightness" "$1"
    }

    if [[ "$action" != "up" && "$action" != "down" ]]; then
      notify_error "Usage: niri-ddc-brightness up|down"
      exit 2
    fi

    if ! bus="$(resolve_bus)"; then
      notify_error "Failed to detect DDC/CI bus for display $target_display"
      exit 1
    fi

    if ! read -r current max < <(get_brightness_values_from_bus "$bus"); then
      rm -f "$cache_file"
      if ! bus="$(resolve_bus_for_display)" || ! read -r current max < <(get_brightness_values_from_bus "$bus"); then
        notify_error "Failed to read DDC/CI brightness"
        exit 1
      fi
    fi

    if (( max < 1 )); then
      notify_error "Monitor reported invalid brightness range"
      exit 1
    fi

    step=$((max / 10))
    if (( step < 1 )); then
      step=1
    fi

    if [[ "$action" == "up" ]]; then
      target=$((current + step))
    else
      target=$((current - step))
    fi

    if (( target > max )); then
      target=$max
    fi

    if (( target < 0 )); then
      target=0
    fi

    if ! set_brightness_from_bus "$bus" "$target"; then
      rm -f "$cache_file"
      if ! bus="$(resolve_bus_for_display)" || ! set_brightness_from_bus "$bus" "$target"; then
        notify_error "Failed to set DDC/CI brightness"
        exit 1
      fi
    fi

    percent=$((target * 100 / max))

    ${pkgs.libnotify}/bin/notify-send \
      -u low \
      -t 1200 \
      -h string:x-canonical-private-synchronous:brightness \
      -h "int:value:$percent" \
      "Brightness" \
      "$percent%"
  '';
in
{
  config = lib.mkIf config.home-manager.niri.enable {
    home.packages = [
      pkgs.ddcutil
      pkgs.libnotify
      niriDdcBrightness
    ];
  };
}
