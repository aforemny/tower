{ lib, sources, ... }:
{
  options.nixosConfigurations = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        {
          config,
          options,
          name,
          ...
        }:
        {
          options = {
            config = lib.mkOption {
              type = lib.mkOptionType {
                name = "Toplevel NixOS config";
                merge =
                  loc: defs:
                  (import "${config.nixpkgs}/nixos/lib/eval-config.nix" {
                    modules = map (x: x.value) defs;
                  }).config;
              };
            };
            nixpkgs = lib.mkOption {
              type = lib.types.path;
              default = sources.nixpkgs;
            };
          };
        }
      )
    );
    default = { };
  };
}
