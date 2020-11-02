let
  inherit (import <nixpkgs> {}) lib;

  impEntry =
    let
      inherit (builtins)
        pathExists;

      inherit (lib.strings)
        hasSuffix removeSuffix;
    in
      name: kind: (
        if kind == "regular" && name != "default.nix" && hasSuffix ".nix" name
        then {
          name = removeSuffix ".nix" name;
          value = import (./. + "/${name}");
        }
        else if kind == "directory" && pathExists (./. + "/${name}/default.nix")
        then {
          inherit name;
          value = import (./. + "/${name}");
        }
        else {
          inherit name;
          value = null;
        }
      );

  result = 
    let
      inherit (lib.attrsets) mapAttrs' filterAttrs;
      entries = builtins.readDir ./.;
      unfiltered = mapAttrs' impEntry entries;
    in
      filterAttrs (_: v: v != null) unfiltered;
in
  result

