let
  inherit (builtins) pathExists;
  inherit (import <nixpkgs> {}) lib;

  impEntry =
    let
      inherit (lib.strings)
        hasSuffix removeSuffix;
    in
      baseDir: name: kind: (
        if kind == "regular" && name != "default.nix" && hasSuffix ".nix" name
        then {
          name = removeSuffix ".nix" name;
          value = import (baseDir + "/${name}");
        }
        else if kind == "directory" && pathExists (baseDir + "/${name}/default.nix")
        then {
          inherit name;
          value = import (baseDir + "/${name}");
        }
        else {
          inherit name;
          value = null;
        }
      );

in
  dir:
    let
      inherit (lib.attrsets) mapAttrs' filterAttrs;
      entries = builtins.readDir dir;
      unfiltered = mapAttrs' (impEntry dir) entries;
    in
      filterAttrs (_: v: v != null) unfiltered
