let
  inherit (import <nixpkgs> {}) stdenv writeScript;
  inherit (import ./metalib) readTOML;
in
  projdir: poetrylockpath:
    let
      pyproject = readTOML (projdir + "/pyproject.toml");
      poetrylock = readTOML poetrylockpath;
      inherit (pyproject.tool.poetry) name version;
    in
      stdenv.mkDerivation {
        inherit version;
        pname = name;
        src = projdir;
        builder = writeScript "${name}-builder.sh" ''
          echo 'BUILDER NOT IMPLEMENTED.'
        '';
      }
