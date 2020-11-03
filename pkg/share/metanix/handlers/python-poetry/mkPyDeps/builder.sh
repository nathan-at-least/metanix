source "$stdenv/setup"
set -e
archname="$(echo "$src" | sed 's/^[^-]*-//')"
ln -s "$src" "$archname"
pip install --no-deps --prefix "$out" "$archname"
