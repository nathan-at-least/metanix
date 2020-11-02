let
  inherit (builtins) foldl' pathExists;
  inherit (import <nixpkgs> {}) lib;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.debug) traceSeq;

  handlers = {
    "default.nix" = (_: import);
    "poetry.lock" = import ./poetry-handler.nix;
  };
in
  { targetPath }:
  assert builtins.typeOf targetPath == "string";
  let
    targetPathVal = /. + (traceSeq "targetPath ${targetPath}" targetPath);
    mkCandidate = fname: loader: {
      inherit loader;
      targetPath = targetPathVal;
      pkgPath = targetPathVal + "/${fname}";
    };
    candidates = mapAttrsToList mkCandidate handlers;
    load = result: { targetPath, pkgPath, loader }:
      if result != null
      then result
      else if pathExists pkgPath
      then traceSeq "Found:" (traceSeq pkgPath (loader targetPath pkgPath))
      else null;
    result = foldl' load null candidates;
  in
    if result != null
    then result
    else
      builtins.throw "Could not recognize ${targetPathVal} package format."
