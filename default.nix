let
  inherit (import <nixpkgs> {}) cargo fetchurl stdenv writeScript;

  pkginfo =
    with builtins;
    fromTOML (readFile ./package.toml);

  crate2nix =
    let
      pname = "crate2nix";
      version = "0.8.0";
      name = "${pname}-${version}";
      src = stdenv.mkDerivation {
        inherit version;
        pname = "${pname}-src";
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
      import "${src}" {};
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
