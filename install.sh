set -efux
system=$(nix-build -A config.nixosConfigurations.tower.config.system.build.toplevel)
disko=$(nix-build -A config.nixosConfigurations.tower.config.system.build.diskoScript)
tmp=tmp
export ASECRET_OUT="$tmp"/persist/var/src/secrets
mkdir -p "$ASECRET_OUT"
asecret export
NIX_CONFIG='' nixos-anywhere --store-paths "$disko" "$system" --extra-files "$tmp" root@192.168.178.192
