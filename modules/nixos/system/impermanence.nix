{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    system.impermanence.enable = lib.mkEnableOption "Enable Impermanence with a btrfs root filesystem";
  };

  config = lib.mkIf config.system.impermanence.enable {
    fileSystems."/persistent".neededForBoot = true;

    boot.initrd.systemd = {
      services.impermance-btrfs-rolling-root = {
        description = "Archiving existing BTRFS root subvolume and creating a fresh one";
        unitConfig.DefaultDependencies = false;

        serviceConfig = {
          Type = "oneshot";
        };
        requiredBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];

        requires = [ "initrd-root-device.target" ];
        after = [
          "initrd-root-device.target"
          "local-fs-pre.target"
        ];

        script = ''
          mkdir /btrfs_tmp
          mount /dev/root_vg/root /btrfs_tmp
          if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
      extraBin = {
        "mkdir" = "${pkgs.coreutils}/bin/mkdir";
        "date" = "${pkgs.coreutils}/bin/date";
        "stat" = "${pkgs.coreutils}/bin/stat";
        "mv" = "${pkgs.coreutils}/bin/mv";
        "find" = "${pkgs.findutils}/bin/find";
        "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
      };
    };
  };
}
