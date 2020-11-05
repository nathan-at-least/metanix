_imp:
let
  inherit (import <nixpkgs> {}) lib;
  inherit (lib.debug) traceSeq;
  a2j = import ./any2json.nix;
in
  v: traceSeq "${a2j v}" v

