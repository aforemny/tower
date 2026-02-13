{ lib, self, ... }:
{
  imports = lib.filter (fp: lib.hasSuffix ".nix" (toString fp)) (
    lib.filesystem.listFilesRecursive ./src
  );
}
