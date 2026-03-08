{ pkgs }:

{
  niriPowerMenu = pkgs.writeShellScriptBin "niri-power-menu" ''
    #!/usr/bin/env bash

    set -euo pipefail

    selected="$(printf '%s\n' 'Sleep' 'Logout' 'Shutdown' 'Restart' | fuzzel --dmenu --prompt 'Power: ')"

    case "$selected" in
      Sleep)
        systemctl suspend
        ;;
      Logout)
        niri msg action quit
        ;;
      Shutdown)
        systemctl poweroff
        ;;
      Restart)
        systemctl reboot
        ;;
    esac
  '';

  niriActionsMenu = pkgs.writeShellScriptBin "niri-actions-menu" ''
    #!/usr/bin/env bash

    set -euo pipefail

    nmcli_bin="${pkgs.networkmanager}/bin/nmcli"
    notify_bin="${pkgs.libnotify}/bin/notify-send"
    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}"
    last_profile_file="$state_dir/niri-openvpn-last"

    menu() {
      local prompt="$1"
      shift
      printf '%s\n' "$@" | fuzzel --dmenu --prompt "$prompt" || true
    }

    prompt_text() {
      local prompt="$1"
      fuzzel --dmenu --prompt-only "$prompt" || true
    }

    prompt_password() {
      local prompt="$1"
      fuzzel --dmenu --password --prompt-only "$prompt" || true
    }

    is_openvpn_uuid() {
      local uuid="$1"
      local service_type
      service_type="$($nmcli_bin -g vpn.service-type connection show "$uuid" 2>/dev/null || true)"
      [[ "$service_type" == "org.freedesktop.NetworkManager.openvpn" ]]
    }

    list_openvpn_uuids() {
      while IFS=: read -r uuid conn_type; do
        [[ -z "$uuid" ]] && continue
        [[ "$conn_type" != "vpn" ]] && continue
        if is_openvpn_uuid "$uuid"; then
          printf '%s\n' "$uuid"
        fi
      done < <($nmcli_bin -t -f UUID,TYPE connection show)
    }

    active_openvpn_uuid() {
      while IFS=: read -r uuid conn_type; do
        [[ -z "$uuid" ]] && continue
        [[ "$conn_type" != "vpn" ]] && continue
        if is_openvpn_uuid "$uuid"; then
          printf '%s\n' "$uuid"
          return 0
        fi
      done < <($nmcli_bin -t -f UUID,TYPE connection show --active)

      return 1
    }

    connection_name() {
      local uuid="$1"
      $nmcli_bin -g connection.id connection show "$uuid"
    }

    choose_openvpn_uuid() {
      local uuids
      local count
      local selected

      mapfile -t uuids < <(list_openvpn_uuids)
      count="''${#uuids[@]}"

      if (( count == 0 )); then
        return 1
      fi

      if [[ -r "$last_profile_file" ]]; then
        local cached_uuid
        read -r cached_uuid < "$last_profile_file" || true
        for uuid in "''${uuids[@]}"; do
          if [[ "$uuid" == "$cached_uuid" ]]; then
            printf '%s\n' "$uuid"
            return 0
          fi
        done
      fi

      if (( count == 1 )); then
        printf '%s\n' "''${uuids[0]}"
        return 0
      fi

      selected="$({
        for uuid in "''${uuids[@]}"; do
          printf '%s\t%s\n' "$uuid" "$(connection_name "$uuid")"
        done
      } | fuzzel --dmenu --prompt "OpenVPN profile: " --with-nth=2 --accept-nth=1)"

      if [[ -n "$selected" ]]; then
        printf '%s\n' "$selected"
        return 0
      fi

      return 1
    }

    toggle_openvpn() {
      local active_uuid
      local target_uuid
      local profile_name

      if active_uuid="$(active_openvpn_uuid)"; then
        profile_name="$(connection_name "$active_uuid")"
        if $nmcli_bin connection down uuid "$active_uuid" >/dev/null; then
          $notify_bin -u low "OpenVPN" "Disconnected: $profile_name"
        else
          $notify_bin -u normal "OpenVPN" "Failed to disconnect: $profile_name"
        fi
        return
      fi

      if ! target_uuid="$(choose_openvpn_uuid)"; then
        $notify_bin -u normal "OpenVPN" "No OpenVPN profiles found. Import one first."
        return
      fi

      profile_name="$(connection_name "$target_uuid")"
      if $nmcli_bin connection up uuid "$target_uuid" >/dev/null; then
        mkdir -p "$state_dir"
        printf '%s\n' "$target_uuid" > "$last_profile_file"
        $notify_bin -u low "OpenVPN" "Connected: $profile_name"
      else
        $notify_bin -u normal "OpenVPN" "Failed to connect: $profile_name"
      fi
    }

    detect_imported_uuid() {
      local before_uuids="$1"
      local uuid

      while IFS= read -r uuid; do
        [[ -z "$uuid" ]] && continue
        case $'\n'"$before_uuids"$'\n' in
          *$'\n'"$uuid"$'\n'*)
            ;;
          *)
            printf '%s\n' "$uuid"
            return 0
            ;;
        esac
      done < <($nmcli_bin -t -f UUID connection show)

      return 1
    }

    import_openvpn_profile() {
      local ovpn_path
      local username
      local password
      local before_uuids
      local imported_uuid
      local profile_name

      ovpn_path="$(prompt_text "OVPN path: ")"
      [[ -z "$ovpn_path" ]] && return

      if [[ ! -f "$ovpn_path" ]]; then
        $notify_bin -u normal "OpenVPN" "File not found: $ovpn_path"
        return
      fi

      before_uuids="$($nmcli_bin -t -f UUID connection show)"

      if ! $nmcli_bin connection import type openvpn file "$ovpn_path" >/dev/null 2>&1; then
        $notify_bin -u normal "OpenVPN" "Failed to import profile"
        return
      fi

      if ! imported_uuid="$(detect_imported_uuid "$before_uuids")"; then
        $notify_bin -u normal "OpenVPN" "Imported profile, but could not identify it"
        return
      fi

      username="$(prompt_text "VPN username: ")"
      [[ -z "$username" ]] && username=""

      password="$(prompt_password "VPN password: ")"
      [[ -z "$password" ]] && password=""

      if [[ -n "$username" ]]; then
        $nmcli_bin connection modify uuid "$imported_uuid" vpn.user-name "$username"
        $nmcli_bin connection modify uuid "$imported_uuid" +vpn.data "username=$username"
      fi

      if [[ -n "$password" ]]; then
        $nmcli_bin connection modify uuid "$imported_uuid" +vpn.data "password-flags=0"
        $nmcli_bin connection modify uuid "$imported_uuid" +vpn.secrets "password=$password"
      fi

      $nmcli_bin connection modify uuid "$imported_uuid" ipv4.never-default yes ipv6.never-default yes

      profile_name="$(connection_name "$imported_uuid")"
      $notify_bin -u low "OpenVPN" "Imported: $profile_name (split tunnel enabled)"
    }

    openvpn_menu() {
      local selected
      selected="$(menu "OpenVPN: " "Toggle VPN" "Import .ovpn profile")"

      case "$selected" in
        "Toggle VPN")
          toggle_openvpn
          ;;
        "Import .ovpn profile")
          import_openvpn_profile
          ;;
      esac
    }

    selected="$(menu "Actions: " "OpenVPN" "Power")"

    case "$selected" in
      OpenVPN)
        openvpn_menu
        ;;
      Power)
        niri-power-menu
        ;;
    esac
  '';
}
