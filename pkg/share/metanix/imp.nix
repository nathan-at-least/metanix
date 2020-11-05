let
  inherit (import <nixpkgs> {}) fetchFromGitHub;

  impSrc = fetchFromGitHub {
    owner = "nathan-at-least";
    repo = "nix-imp";
    rev = "9c11dc6ac4f5e958df5ab21ec9f879c41aab06ea";
    sha256 = "sha256:12i4kamd1fs61r5w485n233iplibgvhffk10181rfasgkq8hq88l";
  };
  impDer = import "${impSrc}/default.nix";
  mkImporter = import "${impDer}/default.nix";
in
  mkImporter ./.
