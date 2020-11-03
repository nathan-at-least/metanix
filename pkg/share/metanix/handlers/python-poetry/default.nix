{ metalib }:
let
  inherit (builtins) pathExists;
  inherit (import <nixpkgs> {}) stdenv writeScript symlinkJoin;
  inherit (metalib) readTOML traceVal;
  inherit (metalib.impdir ./.) mkPyDeps;
in {
  check = p: pathExists (p + "/poetry.lock");
  load = projdir:
    let
      pyproject = readTOML (projdir + "/pyproject.toml");
      poetrylock = readTOML (projdir + "/poetry.lock");
      inherit (pyproject.tool.poetry) name version;
      inherit (mkPyDeps poetrylock) python pydeps;
    in
      stdenv.mkDerivation {
        inherit version;
        pname = name;
        src = projdir;
        nativeBuildInputs = [
          python
          python.pkgs.pip
          (symlinkJoin {
            name = "${name}-${version}-deps";
            paths = pydeps;
          })
        ];
        builder = writeScript "${name}-builder.sh" ''
          set -x
          echo "$nativeBuildInputs"
        '';
      };
}
