{ self, ... }:
{
  nixosConfigurations.tower.config.imports = [
    self.nixosTemplates.tower
    self.platforms.bareMetal.tower
  ];
  nixosTemplates.tower = {
    networking = {
      hostId = "c32250b5";
      hostName = "tower";
    };
  };
  platforms.bareMetal.tower = {
    imports = [ self.diskos.tower ];
    disko.devices.disk = {
      large.device = "/dev/disk/by-id/ata-ST16000NM000J-2TW103_ZR60JMX3";
      small.device = "/dev/disk/by-id/wwn-0x50014ee2b8b27062";
    };
    facter.reportPath = ./tower.json;
    system.stateVersion = "26.05";
  };
  diskos.tower.disko.devices = {
    disk = {
      large = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            encryptedSwap = {
              size = "32G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            zdata = {
              size = "2T";
              content = {
                type = "zfs";
                pool = "zdata";
              };
            };
            zroot = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      small = {
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            zdata = {
              size = "100%"; # ~2T
              content = {
                type = "zfs";
                pool = "zdata";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "zstd";
          mountpoint = "none";
          xattr = "sa";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
        };
        options = {
          ashift = "12";
        };
        datasets = {
          "local" = {
            type = "zfs_fs";
            options.mountpoint = "none";
            options."com.sun:auto-snapshot" = "false";
          };
          "safe" = {
            type = "zfs_fs";
            options.mountpoint = "none";
            options."com.sun:auto-snapshot" = "true";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/local/root@blank$' || zfs snapshot zroot/local/root@blank";
          };
          "safe/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
          };
        };
      };
      zdata = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          compression = "zstd";
          mountpoint = "none";
          xattr = "sa";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
        };
        options = {
          ashift = "12";
        };
        datasets = {
          "backups" = {
            type = "zfs_fs";
            options.mountpoint = "/backups";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}
