let
  inherit (import <nixpkgs> {})
    cargo fetchurl rustPlatform stdenv writeScript;

  cargotoml = import ./nix/readTOML.nix ./Cargo.toml;
  crate2nix = import ./nix/crate2nix.nix;
in
  rustPlatform.buildRustPackage {
    pname = cargotoml.package.name;
    version = cargotoml.package.version;
    src = ./.;
    cargoSha256 = "sha256:11fpkqncq9cz9bv0axmvm7rak90hjjxn4d5pq6ic8xz04cl1hhvc";
  }
