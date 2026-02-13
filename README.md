# tower

A variation of [cake](https://github.com/aforemny/cake) which differs in

1. a non-flakes, [dendritic](https://github.com/mightyiam/dendritic)-like layout in `./src`,
1. will build non-configurable tooling in `./cli` (not started, currently only `nix repl -f.` can be used for "tooling").

## Reading Notes

- The main entry-point is `./default.nix` which uses the module system to evaluate `./cake.nix` which just auto-imports `./src`.
- The files `./src/{devShells,diskos,nixosConfigurations,nixosModules,nixosTemplates,platforms}` define "cake options".
- The example NixOS configuration consists of `./src/tower.nix`.
- The file `./src/defaults.nix` defines defaults on top of nixpkgs, which are assumed across all NixOS configurations, such as setting specific options, importing specific modules, and activating specific profiles such as `./src/users.nix`.
