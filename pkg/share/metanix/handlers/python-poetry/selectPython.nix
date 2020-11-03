{ metalib }: poetrylock:
let
  inherit (builtins) elemAt isList length match;
  inherit (metalib) check;

  nixpkgs = import <nixpkgs> {};

  rgx = ".*\\^3\.[0-9].*";
  poetvs = poetrylock.metadata."python-versions";
  groups =
    check.value (v: isList v && length v == 2)
    "Couldn't parse python versions: ${poetvs}"
    (match rgx poetvs);
  major = elemAt groups 0;
  minor = elemAt groups 1;
in
  nixpkgs."python39"
