imp:
let
  inherit (import <nixpkgs> {}) fetchurl python39 stdenv writeScript;
  python = python39;

  inherit (builtins) pathExists;
  inherit (imp "/metalib") readTOML;
  inherit (python.pkgs) buildPythonPackage fetchPypi;

  pname = "poetry";
  version = "1.1.4";

in
  stdenv.mkDerivation {
    inherit pname version;

    nativeBuildInputs = [ python39 ];

    releaseArchive = fetchurl {
      url = "https://github.com/python-poetry/poetry/releases/download/${version}/${pname}-${version}-linux.tar.gz";
      sha256 = "sha256:1pb0zbasbvyzg2190nrly05ww1l1l4rryyjrj0icnqsbf37985a6";
    };

    getPoetry = fetchurl {
      url = "https://github.com/python-poetry/poetry/raw/${version}/get-poetry.py";
      sha256 = "sha256:19zlm37bvf02xcka7bqjfgc0y4skfbmjxhjhwazidacmvfxb6wz9";
    };

    builder = writeScript "${pname}-${version}-builder.sh" ''
      source "$stdenv/setup"
      set -x
      POETRY_HOME="$out" \
      python "$getPoetry" \
        --file "$releaseArchive" \
        --no-modify-path \
        --yes \
        > ./get-poetry.log
      rm "$out/env"
      set +x
      cd "$out"
      patchShebangs .
    '';
  }
