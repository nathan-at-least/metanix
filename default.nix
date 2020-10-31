let
  inherit (import <nixpkgs> {}) cargo fetchurl stdenv writeScript;

  pkginfo =
    with builtins;
    fromTOML (readFile ./package.toml);

  crate2nix = import ./nix/crate2nix.nix;
in
  stdenv.mkDerivation rec {
    inherit (pkginfo) pname version;
    src = ./.;
    nativeBuildInputs = [
      cargo crate2nix
    ];
    builder = writeScript "${pname}-builder.sh" ''
      source "$stdenv/setup"
      mkdir -p "$out/bin"
      cat "$src/pkg/bin/metanix" \
        | sed 's|^readonly CARGO=.*$|readonly CARGO="${cargo}/bin/cargo"|' \
        | sed 's|^readonly CRATE2NIX=.*$|readonly CRATE2NIX="${crate2nix}/bin/crate2nix"|' \
        > "$out/bin/metanix"
      chmod ugo+x "$out/bin"/*
      cp -a "$src"/pkg/share "$out/share"
    '';
  }
