let
  inherit (import <nixpkgs> {}) cargo fetchurl stdenv writeScript;

  pkginfo = builtins.fromTOML (builtins.readFile ./package.toml);
in
  stdenv.mkDerivation rec {
    inherit (pkginfo) pname version;
    src = ./pkg;
    builder = writeScript "${pname}-builder.sh" ''
      source "$stdenv/setup"
      mkdir -p "$out/"
      cp -a "$src"/* "$out/"
    '';
  }
