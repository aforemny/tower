{
  pkgs ? import sources.nixpkgs { },
  sources ? import ./npins,
}:
let
  inherit (pkgs) lib;
  self = lib.evalModules {
    modules = [ ./cake.nix ];
    specialArgs = {
      self = self.config;
      inherit lib sources;
    };
  };
in
{
  inherit (self) config options;
  inherit lib sources;
}
