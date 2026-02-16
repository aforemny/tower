#! /usr/bin/env bash

set -efux

target=root@192.168.178.192
system=$(nix-build -A config.nixosConfigurations.tower.config.system.build.toplevel)
nix-copy-closure --to "$target" "$system"
ASECRET_OUT=$target:/persist/var/src/secrets asecret export
ssh ${NIX_SSHOPTS+$NIX_SSHOPTS} "$target" 'nix-env --profile /nix/var/nix/profiles/system --set '"'$system'"
#ssh "$target" "$system"/activate
ssh ${NIX_SSHOPTS+$NIX_SSHOPTS} "$target" "$system"/bin/switch-to-configuration switch # 815
