imp: python:
let
  inherit (builtins) pathExists;
  inherit (imp "/metalib") readTOML;
  mkPyDeps = imp "mkPyDeps";
  inherit (python.pkgs) buildPythonPackage fetchPypi;
in
  buildPythonPackage rec {
    pname = "poetry-core";
    version = "1.0.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "08fdd5ef7c96480ad11c12d472de21acd32359996f69a5259299b540feba4560";
    };

    doCheck = false;
  }
