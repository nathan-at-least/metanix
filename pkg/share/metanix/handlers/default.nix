{ metalib }:
let
  inherit (import <nixpkgs> {}) lib;
  inherit (lib.attrsets) mapAttrsToList;
  mods = metalib.impdir ./.;
in
  mapAttrsToList (name: a: a // { inherit name; }) mods
