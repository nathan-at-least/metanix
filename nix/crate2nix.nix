let
  inherit (import <nixpkgs> {})
    fetchurl stdenv writeScript;

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
  import "${src}" {}
