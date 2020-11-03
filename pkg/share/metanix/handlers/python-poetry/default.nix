{ metalib }:
let
  inherit (builtins) pathExists;
  inherit (import <nixpkgs> {}) stdenv writeScript symlinkJoin;
  inherit (metalib) readTOML traceVal;
  inherit (metalib.impdir ./.) mkPyDeps selectPython mkPoetryCore;
in {
  check = p: pathExists (p + "/poetry.lock");
  load = projdir:
    let
      pyproject = readTOML (projdir + "/pyproject.toml");
      poetrylock = readTOML (projdir + "/poetry.lock");
      inherit (pyproject.tool.poetry) name version;

      python = selectPython pyproject;
      pydeps = mkPyDeps python poetrylock;
      poetryCore = mkPoetryCore python;
    in
      stdenv.mkDerivation {
        inherit version poetryCore;
        pname = name;
        src = projdir;
        nativeBuildInputs = [
          python
          python.pkgs.pip
          poetryCore
        ] ++ pydeps;
        builder = writeScript "${name}-builder.sh" ''
          source "$stdenv/setup"
          export PYTHONPATH="$(echo "$PYTHONPATH" | tr ':' '\n' | sort -u | tr '\n' ':')"
          pip install --no-deps --prefix "$out" "$src"
        '';
      };
}
