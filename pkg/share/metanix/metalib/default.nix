let
  rawimpdir = import ./impdir.nix;
  rawmetalib = rawimpdir ./.;
  metalib = rawmetalib // { impdir = cookedimpdir; };
  cookedimpdir = d:
    let
      inherit (builtins) mapAttrs;
      cookmod = _: m: m { inherit metalib; };
    in
      mapAttrs cookmod (rawimpdir d);
in
  metalib
