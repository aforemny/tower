{ lib, self, ... }:
{
  options.diskos = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
  };
}
