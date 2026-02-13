{
  lib,
  self,
  sources,
  ...
}:
{
  config.nixosModules.users =
    { config, pkgs, ... }:
    lib.mkMerge [
      {
        users = {
          mutableUsers = false;
          users.root.hashedPasswordFile = config.users.users.aforemny.hashedPasswordFile;
        };
      }
      {
        users = {
          groups.aforemny.gid = config.users.users.aforemny.uid;
          users.aforemny = {
            extraGroups = [
              "audio"
              "dialout"
              "scanner"
              "video"
              "wheel"
              "users"
            ];
            group = "aforemny";
            isNormalUser = true;
            hashedPasswordFile = "/persist/${pkgs.asecret-lib.hashedPassword "per-user/aforemny/hashed-password"}";
            uid = 1000;
          };
        };
      }
    ];
}
