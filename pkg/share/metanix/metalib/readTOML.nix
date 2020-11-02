let
  inherit (builtins) fromTOML readFile;
in
  p: fromTOML (readFile p)
