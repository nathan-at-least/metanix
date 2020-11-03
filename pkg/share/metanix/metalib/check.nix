rec {
  value = pred: msg: val:
    if pred val
    then val
    else builtins.throw msg;

  notNull = value (v: v != null);
}
