{
  lib,
  self,
  sources,
  ...
}:
let
  sshPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvRliydgYlyjKeMAEuVWWvmr82rZBXaA5ZM9U8r0pyN aforemny@x1e";
in
{
  config.nixosModules.users =
    { config, pkgs, ... }:
    lib.mkMerge [
      {
        users = {
          mutableUsers = false;
          users.root = {
            hashedPasswordFile = config.users.users.aforemny.hashedPasswordFile;
            openssh.authorizedKeys.keys = [ sshPubKey ];
          };
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
            hashedPasswordFile = "/persist${pkgs.asecret-lib.hashedPassword "per-user/aforemny/hashed-password"}";
            uid = 1000;
            openssh.authorizedKeys.keys = [ sshPubKey ];
          };
        };
      }
    ];
}
