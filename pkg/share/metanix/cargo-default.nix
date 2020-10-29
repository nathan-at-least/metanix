let 
  inherit (import <nixpkgs> {}) callPackage;
  cargopkg = callPackage ./Cargo.nix {};
in
  cargopkg.rootCrate.build
