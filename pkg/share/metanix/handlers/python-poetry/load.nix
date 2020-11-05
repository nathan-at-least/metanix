imp:
let
  inherit (import <nixpkgs> {}) stdenv writeScript;
  inherit (imp "/metalib") readTOML;
in
  projdir:
    let
      pyproject = readTOML (projdir + "/pyproject.toml");
      inherit (pyproject.tool.poetry) name version;

      poetryDeps = imp "mkPoetryDeps" projdir;
    in
      stdenv.mkDerivation {
        inherit version;
        pname = name;
        src = projdir;
        nativeBuildInputs = poetryDeps ++ [
          (imp "poetry")
        ];
        builder = writeScript "${name}-${version}-metanix-builder.sh" ''
          source "$stdenv/setup"
          poetry --help
        '';
      }
