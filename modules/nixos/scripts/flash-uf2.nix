{ pkgs, ... }:

let
  flashUf2 = pkgs.writeShellScriptBin "flash-uf2" ''
    #!/usr/bin/env bash
    set -euo pipefail

    UF2="''${1:?Usage: $0 /path/to/firmware.uf2 [LABEL_REGEX]}"
    LABEL_REGEX="''${2:-ADV360|NICENANO|UF2|BOOT}"

    if [ ! -f "$UF2" ]; then
      echo "Firmware file not found: $UF2"
      exit 1
    fi

    run_udisksctl() {
      ${pkgs.udisks}/bin/udisksctl "$@"
    }

    echo "Waiting for bootloader volume..."
    echo "Will flash: $UF2"

    while true; do
      LSBLK_OUT="$(lsblk -rpo NAME,RM,TYPE,FSTYPE,MOUNTPOINT,LABEL || true)"

      CANDIDATES="$(printf '%s\n' "$LSBLK_OUT" | awk -v re="$LABEL_REGEX" '
        {
          name=$1
          rm=$2
          type=$3
          fs=$4
          mount=""
          label=""

          if (NF >= 6) {
            mount=$5
            label=$6
          } else if (NF == 5) {
            label=$5
          }

          if (rm==1 && (type=="part" || type=="disk") && fs~/^(vfat|fat|msdos)$/ && mount=="" && label~re) {
            print name
          }
        }
      ')"

      DEV="$(printf '%s\n' "$CANDIDATES" | awk 'NR==1 {print; exit}')"

      if [ -n "''${DEV:-}" ]; then
        echo "Found $DEV, mounting..."
        if ! OUT="$(run_udisksctl mount -b "$DEV" 2>&1)"; then
          echo "Mount command failed for $DEV"
          printf '%s\n' "$OUT"
          exit 1
        fi

        MP="$(lsblk -nrpo MOUNTPOINT "$DEV" | awk 'NF { print; exit }')"
        if [ -z "$MP" ]; then
          MP="$(printf '%s\n' "$OUT" | sed -n 's/.* at \(.*\)\.?$/\1/p')"
        fi

        if [ -z "$MP" ]; then
          echo "Could not determine mount point."
          exit 1
        fi

        cp "$UF2" "$MP/"
        sync
        if ! run_udisksctl unmount -b "$DEV" >/dev/null 2>&1; then
          echo "Device already disconnected after flash; skipping unmount."
        fi
        echo "Flashed successfully."
        exit 0
      fi

      sleep 0.2
    done
  '';
in
{
  environment.systemPackages = [
    flashUf2
  ];
}
