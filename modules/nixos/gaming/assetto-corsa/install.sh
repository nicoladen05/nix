if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
  echo "Please do not run as root."
  exit 1
fi

GE_VERSION="${GE_VERSION:-9-20}"
CSP_VERSION="${CSP_VERSION:-0.2.11}"
INSTALL_DXVK_BY_DEFAULT="${INSTALL_DXVK_BY_DEFAULT:-0}"

LOCAL="$HOME/.local"
STEAM_ROOT="$LOCAL/share/Steam"
STEAM_LIBRARY_VDF="$STEAM_ROOT/steamapps/libraryfolders.vdf"
AC_DESKTOP="$LOCAL/share/applications/Assetto Corsa.desktop"
APPLAUNCH_AC="steam -applaunch 244210 %u"

AC_COMMON=""
STEAMAPPS=""
AC_COMPATDATA=""
PREFIX_RESET="0"

bold=$(tput bold)
normal=$(tput sgr0)

error() {
  echo "${bold}ERROR${normal}: $1"
  exit 1
}

warn() {
  echo "${bold}WARNING${normal}: $1"
}

ask() {
  echo
  while true; do
    read -r -p "$* [y/n]: " yn
    case "$yn" in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
    esac
  done
}

run_protontricks() {
  local output=""
  if ! output="$(STEAM_RUNTIME=1 protontricks "$@" 2>&1)"; then
    echo "$output"

    if [[ "$output" == *"Could not find configured Proton installation"* ]] || [[ "$output" == *"Active Proton installation could not be found automatically"* ]]; then
      cat <<EOF
Protontricks could not determine the Proton version for Assetto Corsa.
In Steam, do the following:
  1. Assetto Corsa -> Properties -> Compatibility
  2. Enable "Force the use of a specific Steam Play compatibility tool"
  3. Select a GE-Proton version
  4. Launch Assetto Corsa once, wait for it to open, then close the game and Steam
Then rerun assetto-corsa-install.
EOF
    elif [[ "$output" == *"Wine cannot find the FreeType font library"* ]]; then
      cat <<EOF
Wine failed to start because FreeType was missing while Steam Runtime was disabled.
The script now forces STEAM_RUNTIME=1 for protontricks calls on NixOS.
Please rerun assetto-corsa-install.
EOF
    fi

    return 1
  fi

  return 0
}

require_commands() {
  local missing=()
  local deps=(awk basename cp dirname gio grep ln mkdir mv pgrep protontricks rm sed unzip wget)

  for dep in "${deps[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      missing+=("$dep")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    error "Missing commands: ${missing[*]}. Rebuild your system to include them."
  fi
}

check_steam_install() {
  if [[ ! -d "$STEAM_ROOT" ]]; then
    error "Steam directory not found at '$STEAM_ROOT'. Start Steam once and rerun this script."
  fi

  if [[ ! -f "$STEAM_LIBRARY_VDF" ]]; then
    error "Steam library file not found at '$STEAM_LIBRARY_VDF'. Start Steam once and rerun this script."
  fi
}

set_paths_for_assettocorsa() {
  AC_COMMON="$1"
  STEAMAPPS="${AC_COMMON%"/common/assettocorsa"}"
  AC_COMPATDATA="$STEAMAPPS/compatdata/244210"
}

check_assetto_process() {
  local ac_pid=""
  ac_pid="$(pgrep -f "AssettoCorsa.exe" || true)"
  if [[ -n "$ac_pid" ]]; then
    ask "Assetto Corsa is running. Stop it to proceed?" || exit 1
    kill "$ac_pid" || error "Could not stop Assetto Corsa"
  fi
}

find_ac_installation() {
  local default_ac="$STEAM_ROOT/steamapps/common/assettocorsa"
  if [[ -d "$default_ac" ]]; then
    echo "Found ${bold}$default_ac${normal}."
    if ask "Use this installation?"; then
      set_paths_for_assettocorsa "$default_ac"
      return
    fi
  fi

  local path_list=""
  path_list="$(grep '"path"' "$STEAM_LIBRARY_VDF" | awk -F'"' '{print $4}' || true)"

  if [[ -n "$path_list" ]]; then
    while IFS= read -r library_path; do
      [[ -z "$library_path" ]] && continue
      local ac_path="$library_path/steamapps/common/assettocorsa"
      if [[ -d "$ac_path" ]]; then
        echo "Found ${bold}$ac_path${normal}."
        if ask "Use this installation?"; then
          set_paths_for_assettocorsa "$ac_path"
          return
        fi
      fi
    done <<< "$path_list"
  fi

  while true; do
    echo "Enter path to ${bold}steamapps/common/assettocorsa${normal}:"
    read -r -e -i "$PWD/" AC_COMMON
    AC_COMMON="${AC_COMMON%"/"}"
    AC_COMMON="${AC_COMMON/#\~\//$HOME/}"
    if [[ -d "$AC_COMMON" ]] && [[ "$(basename "$AC_COMMON")" == "assettocorsa" ]]; then
      set_paths_for_assettocorsa "$AC_COMMON"
      return
    fi
    echo "Invalid directory."
  done
}

start_menu_shortcut() {
  local link_file="$AC_COMPATDATA/pfx/drive_c/users/steamuser/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Content Manager.lnk"
  if [[ -f "$link_file" ]]; then
    echo "A Content Manager start menu shortcut was found and can cause startup crashes."
    ask "Delete the shortcut?" && rm -f "$link_file"
  fi
}

remove_prefix() {
  local backup_dir
  backup_dir="$(mktemp -d)"

  local ac_config_dir="$AC_COMPATDATA/pfx/drive_c/users/steamuser/Documents/Assetto Corsa"
  local cm_config_dir="$AC_COMPATDATA/pfx/drive_c/users/steamuser/AppData/Local/AcTools Content Manager"

  if [[ -d "$ac_config_dir" ]]; then
    echo "Saving AC configs and presets..."
    cp -r "$ac_config_dir" "$backup_dir/" || error "Failed to back up AC configuration"
  fi

  if [[ -d "$cm_config_dir" ]]; then
    echo "Saving CM configs and presets..."
    cp -r "$cm_config_dir" "$backup_dir/" || error "Failed to back up CM configuration"
  fi

  if [[ -d "$AC_COMPATDATA" ]]; then
    echo "Deleting Wineprefix..."
    rm -rf "$AC_COMPATDATA" || error "Failed to delete '$AC_COMPATDATA'"
  fi

  if [[ -d "$backup_dir/Assetto Corsa" ]]; then
    echo "Restoring AC configs and presets..."
    mkdir -p "$(dirname "$ac_config_dir")"
    cp -r "$backup_dir/Assetto Corsa" "$ac_config_dir" || error "Failed to restore AC configuration"
  fi

  if [[ -d "$backup_dir/AcTools Content Manager" ]]; then
    echo "Restoring CM configs and presets..."
    mkdir -p "$(dirname "$cm_config_dir")"
    cp -r "$backup_dir/AcTools Content Manager" "$cm_config_dir" || error "Failed to restore CM configuration"
  fi

  rm -rf "$backup_dir"

  local ac_exe="$AC_COMMON/AssettoCorsa.exe"
  local ac_original_exe="$AC_COMMON/AssettoCorsa_original.exe"
  if [[ -f "$ac_original_exe" ]]; then
    echo "Restoring original AC executable..."
    rm -f "$ac_exe"
    mv "$ac_original_exe" "$ac_exe" || error "Failed to restore original AssettoCorsa.exe"
  fi

  PREFIX_RESET="1"
}

check_prefix() {
  if [[ -d "$AC_COMPATDATA/pfx" ]]; then
    echo "Found an existing Wineprefix."
    if ask "Delete existing Wineprefix and Content Manager? (preserves configs/presets/mods; choose 'n' if you already regenerated it)"; then
      remove_prefix
    else
      echo "Keeping existing Wineprefix."
    fi
  fi
}

check_generated_files() {
  if [[ ! -f "$AC_COMPATDATA/pfx/system.reg" ]]; then
    cat <<EOF
Before proceeding, generate the Wineprefix first:
  1. Launch Assetto Corsa with any available Proton-GE version
  2. Wait for Assetto Corsa to open
  3. Exit Assetto Corsa
Then run this script again.
EOF
    exit 1
  fi
}

check_proton_ge() {
  local compat_tools_dir="$STEAM_ROOT/compatibilitytools.d"
  local ge_dir="$compat_tools_dir/GE-Proton$GE_VERSION"

  echo "Proton-GE $GE_VERSION is the recommended tested version."

  if [[ -d "$ge_dir" ]]; then
    echo "Detected Proton-GE at: $ge_dir"
    return
  fi

  cat <<EOF
No matching folder was found in $compat_tools_dir.
This is expected on NixOS when Proton-GE is provided via programs.steam.extraCompatPackages,
because Steam gets compatibility tools from Nix store paths (via wrapper environment), not only from
~/.local/share/Steam/compatibilitytools.d.

If Proton-GE appears in Steam's compatibility tool dropdown, you are good to continue.
EOF
}

install_content_manager() {
  local tmp_dir
  tmp_dir="$(mktemp -d)"

  echo "Installing Content Manager..."
  wget -q "https://acstuff.club/app/latest.zip" -O "$tmp_dir/latest.zip" || error "Failed to download Content Manager"
  unzip -q "$tmp_dir/latest.zip" -d "$tmp_dir" || error "Failed to extract Content Manager"

  mv "$tmp_dir/Content Manager.exe" "$tmp_dir/AssettoCorsa.exe" || error "Content Manager executable not found"
  mv -n "$AC_COMMON/AssettoCorsa.exe" "$AC_COMMON/AssettoCorsa_original.exe" || true
  cp -r "$tmp_dir/." "$AC_COMMON/" || error "Failed to copy Content Manager files"

  rm -rf "$tmp_dir"

  tmp_dir="$(mktemp -d)"
  echo "Installing fonts required for Content Manager..."
  wget -q "https://files.acstuff.ru/shared/T0Zj/fonts.zip" -O "$tmp_dir/fonts.zip" || error "Failed to download CM fonts"
  unzip -qo "$tmp_dir/fonts.zip" -d "$tmp_dir" || error "Failed to extract CM fonts"
  mkdir -p "$AC_COMMON/content/fonts"
  cp -r "$tmp_dir/system" "$AC_COMMON/content/fonts/" || error "Failed to install CM fonts"
  rm -rf "$tmp_dir"

  echo "Creating Steam loginusers symlink for Content Manager..."
  local link_from="$LOCAL/share/Steam/config/loginusers.vdf"
  local link_to="$AC_COMPATDATA/pfx/drive_c/Program Files (x86)/Steam/config/loginusers.vdf"
  mkdir -p "$(dirname "$link_to")"
  ln -sf "$link_from" "$link_to" || error "Failed to create loginusers.vdf symlink"

  if [[ -f "$AC_DESKTOP" ]]; then
    local escaped_applaunch
    escaped_applaunch="$(printf '%s' "$APPLAUNCH_AC" | sed 's/[&/]/\\&/g')"
    sed -i "s|steam steam://rungameid/244210|$escaped_applaunch|g" "$AC_DESKTOP"
    gio mime x-scheme-handler/acmanager "Assetto Corsa.desktop" >/dev/null 2>&1 || true
  else
    echo "Assetto Corsa .desktop file not found, acmanager:// links will not be registered automatically."
  fi

  echo "When Content Manager asks for the game folder, use ${bold}Z:$AC_COMMON${normal}"
}

check_content_manager() {
  if [[ -f "$AC_COMMON/AssettoCorsa_original.exe" ]]; then
    if ask "Reinstall Content Manager?"; then
      install_content_manager
    else
      echo "Skipping Content Manager reinstall."
    fi
  else
    if ask "Install Content Manager?"; then
      install_content_manager
    else
      echo "Skipping Content Manager installation."
    fi
  fi
}

install_csp() {
  local user_reg="$AC_COMPATDATA/pfx/user.reg"
  if [[ -f "$user_reg" ]]; then
    if ! grep -q '"dwrite"="native,builtin"' "$user_reg"; then
      echo "Adding DLL override 'dwrite'..."
      if grep -q '"\*d3d11"="native"' "$user_reg"; then
        sed -i '/"\*d3d11"="native"/a "dwrite"="native,builtin"' "$user_reg"
      else
        printf '\n[Software\\Wine\\DllOverrides]\n"dwrite"="native,builtin"\n' >> "$user_reg"
      fi
    else
      echo "DLL override 'dwrite' already present."
    fi
  fi

  local tmp_dir
  tmp_dir="$(mktemp -d)"

  echo "Downloading CSP v$CSP_VERSION..."
  wget -q "https://acstuff.club/patch/?get=$CSP_VERSION" -O "$tmp_dir/csp.zip" || error "Failed to download CSP"

  echo "Installing CSP..."
  unzip -qo "$tmp_dir/csp.zip" -d "$tmp_dir" || error "Failed to extract CSP"
  cp -r "$tmp_dir/." "$AC_COMMON" || error "Failed to copy CSP files"
  rm -rf "$tmp_dir"

  echo "Installing corefonts required for CSP (this may take a while)..."
  if ! run_protontricks 244210 corefonts; then
    warn "Could not install corefonts automatically. Continuing CSP install without it."
    cat <<EOF
If text rendering in Content Manager/CSP is broken, retry manually with:
  protontricks 244210 corefonts
EOF
  fi
}

check_csp() {
  local data_manifest_file="$AC_COMMON/extension/config/data_manifest.ini"
  local current_csp_version=""

  if [[ -f "$data_manifest_file" ]]; then
    current_csp_version="$(grep '^SHADERS_PATCH=' "$data_manifest_file" | sed 's/SHADERS_PATCH=//' || true)"
  fi

  if [[ -z "$current_csp_version" ]]; then
    if ask "Install CSP v$CSP_VERSION?"; then
      install_csp
    else
      echo "Skipping CSP installation."
    fi
  elif [[ "$current_csp_version" == "$CSP_VERSION" ]]; then
    if ask "Reinstall CSP v$CSP_VERSION?"; then
      install_csp
    else
      echo "Keeping existing CSP v$current_csp_version."
    fi
  else
    if ask "CSP v$current_csp_version is installed. Install v$CSP_VERSION instead?"; then
      install_csp
    else
      echo "Keeping existing CSP v$current_csp_version."
    fi
  fi
}

fix_csp_config() {
  local cfg_file="$AC_COMMON/extension/config/data_alt_mapping.ini"
  if [[ ! -f "$cfg_file" ]]; then
    return
  fi

  if grep -q '\[NAMES_WINE\]' "$cfg_file"; then
    sed -i '/\[NAMES_WINE\]/,$d' "$cfg_file" || error "Failed to adjust CSP mapping file"
  fi
}

check_csp_config() {
  local cfg_file="$AC_COMMON/extension/config/data_alt_mapping.ini"
  if [[ ! -f "$cfg_file" ]]; then
    return
  fi

  if grep -q '\[NAMES_WINE\]' "$cfg_file"; then
    echo "Resolve possible input mapping issues?"
    if ask "Only do this if you currently have input mapping issues"; then
      fix_csp_config
    else
      echo "Skipping CSP input mapping change."
    fi
  fi
}

install_dxvk() {
  echo "Installing DXVK via protontricks..."
  if ! run_protontricks --no-background-wineserver 244210 dxvk; then
    error "Could not install DXVK"
  fi
}

main() {
  require_commands
  check_steam_install
  check_assetto_process
  find_ac_installation
  start_menu_shortcut
  check_prefix

  if [[ "$PREFIX_RESET" == "1" ]]; then
    cat <<EOF
Wineprefix reset completed.
Now launch Assetto Corsa once with Proton-GE, wait for it to open, close it, then rerun assetto-corsa-install.
EOF
    exit 0
  fi

  check_proton_ge
  check_generated_files
  check_content_manager
  check_csp

  if [[ "$INSTALL_DXVK_BY_DEFAULT" == "1" ]]; then
    if ask "Install DXVK?"; then
      install_dxvk
    else
      echo "Skipping DXVK installation."
    fi
  else
    if ask "Install DXVK? (can help performance on some servers)"; then
      install_dxvk
    else
      echo "Skipping DXVK installation."
    fi
  fi

  check_csp_config
  echo "${bold}All done!${normal}"
}

main "$@"
