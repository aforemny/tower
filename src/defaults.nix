{
  lib,
  self,
  sources,
  ...
}:
{
  config = {
    nixosModules.defaults = lib.mkDefault {
      boot.initrd.systemd.enable = true;
      boot.loader.systemd-boot.enable = true;
      networking.networkmanager.enable = true;
    };
  };
  options.nixosConfigurations = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          config.config.imports = [
            "${sources.asecret}/modules"
            "${sources.disko}/module.nix"
            "${sources.home-manager}/nixos"
            "${sources.impermanence}/nixos.nix"
            "${sources.nixos-facter-modules}/modules/nixos/facter.nix"
            self.nixosModules.defaults
            self.nixosModules.users
          ];
        }
      )
    );
  };
}
