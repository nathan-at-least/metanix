let
  inherit (import <nixpkgs> {}) lib;
  inherit (lib.attrsets) mapAttrsToList;
  impdir = import ../impdir.nix;
  mods = impdir ./.;
in
  mapAttrsToList (name: a: a // { inherit name; }) mods
