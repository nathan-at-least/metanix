{ metalib }:
{
  check = p: builtins.pathExists (p + "/default.nix");
  load = import;
}
