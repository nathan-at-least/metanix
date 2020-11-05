_imp:
let
  inherit (builtins) attrNames functionArgs mapAttrs toJSON typeOf;
  inherit (import <nixpkgs> {}) lib;
  inherit (lib.strings) concatStringsSep;

  handlers = {
    set = mapAttrs (_: any2jsonObj);
    list = map any2jsonObj;
    lambda = f:
      let argnames = attrNames (functionArgs f);
      in if argnames == []
      then "<lambda _>"
      else "<lambda { ${concatStringsSep ", " argnames} }>";
  };

  any2jsonObj = any: (handlers."${typeOf any}" or (x: x)) any;
in
  any: toJSON (any2jsonObj any)
