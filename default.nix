let
  inherit (import <nixpkgs> {}) fetchurl stdenv writeScript;

  pkginfo =
    with builtins;
    fromTOML (readFile ./package.toml);

  crate2nix =
    let
      pname = "crate2nix";
      version = "0.8.0";
      name = "${pname}-${version}";
    in
      stdenv.mkDerivation {
        inherit pname version;
        src = fetchurl {
          name = "${name}.tar.gz";
          url = "https://github.com/kolloch/${pname}/tarball/${version}";
          sha256 = "sha256:1rwi9pfzqaiaxzixssi2h7xajlkwcqfdcx2i9rh9dnjcrzf09bdl";
        };
        builder = writeScript "${name}-builder.sh" ''
          source "$stdenv/setup"
          set -e
          mkdir "$out"
          cd "$out"
          tar -xf "$src" --strip-components 1
        '';
      };
in
  stdenv.mkDerivation rec {
    inherit (pkginfo) pname version;
    src = ./.;
    nativeBuildInputs = [
      crate2nix
    ];
    builder = writeScript "${pname}-builder.sh" ''
      source "$stdenv/setup"
      mkdir -p "$out"
      cp -a "$src"/pkg/* "$out"
    '';
  }
