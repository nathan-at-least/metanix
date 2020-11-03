{ metalib }:
let
  inherit (builtins) pathExists;
  inherit (import <nixpkgs> {}) stdenv writeScript;
  inherit (metalib) readTOML;
in {
  check = p: pathExists (p + "/poetry.lock");
  load = projdir:
    let
      pyproject = readTOML (projdir + "/pyproject.toml");
      poetrylock = readTOML (projdir + "/poetry.lock");

      inherit (pyproject.tool.poetry) name version;
    in
      stdenv.mkDerivation {
        inherit version;
        pname = name;
        src = projdir;
        builder = writeScript "${name}-builder.sh" ''
          echo 'BUILDER NOT IMPLEMENTED.'
        '';
      };
}
