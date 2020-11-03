{ metalib }:
let
  inherit (builtins) elemAt isList length match split substring toJSON;
  nixpkgs = import <nixpkgs> {};
  inherit (nixpkgs) fetchurl lib stdenv writeScript;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) findFirst;
  inherit (lib.strings) hasSuffix;
  inherit (metalib) check traceVal;
in
  python: poetry:
    let
      mkDep = { name, version, ... }:
        let
          finfos = poetry.metadata.files."${name}";
          fHasSuffix = suffix: {file, hash}: hasSuffix suffix file;
          tarball = findFirst (fHasSuffix ".tar.gz") null finfos;
          wheelOrTarball = findFirst (fHasSuffix ".whl") tarball finfos;
          finfo =
            check.notNull 
            "Couldn't find file for ${name} ${version}: ${toJSON finfos}"
            wheelOrTarball;

          fname = finfo.file;
          sha256 = finfo.hash;
          url =
            if hasSuffix ".whl" fname
            then
              let
                pyvers = elemAt (split "-" fname) 4;
              in
                "https://files.pythonhosted.org/packages/${pyvers}/${substring 0 1 name}/${name}/${fname}"
            else
              "https://files.pythonhosted.org/packages/source/${fname}";
        in
          stdenv.mkDerivation {
            inherit version;
            pname = "python${python.pythonVersion}-${name}";
            src = fetchurl {
              inherit sha256 url;
            };
            nativeBuildInputs = [
              python
              python.pkgs.pip
              python.pkgs.setuptools
              python.pkgs.wheel
            ];
            pyLibPrefix = python.libPrefix;
            builder = ./builder.sh;
          };
    in
      map mkDep poetry.package
