let
  inherit (builtins) foldl' pathExists throw;
  inherit (import <nixpkgs> {}) lib;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.debug) traceSeq;
  inherit (lib.lists) findFirst;

  handlers = import ./handlers {
    metalib = import ./metalib;
  };
in
  { targetPath }:
  assert builtins.typeOf targetPath == "string";
  let
    pathVal = /. + targetPath;
    handler = findFirst (handler: handler.check pathVal) null handlers;
  in
    if handler == null
    then throw "Could not recognize ${targetPath} package format."
    else traceSeq "Recognized package format ${handler.name}" (
      handler.load pathVal
    )
