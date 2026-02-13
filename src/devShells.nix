{ lib, sources, ... }:
{
  options.devShells = lib.mkOption {
    type = lib.types.attrsOf lib.types.package;
    default = { };
  };
  config.devShells.default =
    let
      pkgs = import sources.nixpkgs { overlays = [ (import "${sources.asecret}/pkgs") ]; };
      inherit (pkgs) lib;
    in
    pkgs.mkShell {
      buildInputs = with pkgs; [
        asecret
        nixVersions.nix_2_30
        npins
      ];
      shellHook = ''
        export PASSWORD_STORE_DIR=${lib.escapeShellArg (toString ./..)}/secrets
        export NIX_CONFIG="
          plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
          extra-builtins-file = ${toString sources.asecret}/extra-builtins.nix
        "
      '';
    };
}
