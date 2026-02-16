{
  lib,
  self,
  sources,
  ...
}:
{
  config = {
    nixosModules.defaults = {
      boot = {
        initrd.systemd.enable = lib.mkDefault true;
        loader.systemd-boot.enable = lib.mkDefault true;
      };
      networking.networkmanager.enable = lib.mkDefault true;
      services.openssh = {
        enable = lib.mkDefault true;
        openFirewall = lib.mkDefault true;
      };
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
