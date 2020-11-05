let
  imp = import ./imp.nix;

  inherit (builtins) foldl' pathExists throw;
  inherit (import <nixpkgs> {}) lib;
  inherit (lib.debug) traceSeq;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) findFirst;

  handlers = mapAttrsToList (name: a: a // { inherit name; }) (imp "handlers");
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
