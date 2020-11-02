let
  inherit (builtins) foldl' pathExists;
  inherit (import <nixpkgs> {}) lib;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.debug) traceSeq;

  handlers = {
    "default.nix" = import;
  };
in
  { targetPath }:
  let
    targetPathVal = /. + (traceSeq "targetPath ${targetPath}; type: ${builtins.typeOf targetPath}" targetPath);
    mkCandidate = fname: loader: {
      inherit loader;
      path = targetPathVal + "/${fname}";
    };
    candidates = mapAttrsToList mkCandidate handlers;
    load = result: { path, loader }:
      if result != null
      then result
      else if pathExists path
      then traceSeq "Found:" (traceSeq path (loader path))
      else null;
    result = foldl' load null candidates;
  in
    if result != null
    then result
    else
      builtins.throw "Could not recognize ${targetPathVal} package format."
