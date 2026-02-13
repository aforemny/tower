{ lib, ... }:
{
  options.nixosTemplates = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
  };
}
