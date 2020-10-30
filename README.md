# metanix

Install software with nix by heuristically generating nix build info.

## Example

This example clones an arbitrary cargo crate, then installs it with `metanix`:

```bash
$ git clone 'https://github.com/nathan-at-least/cargo-checkmate'
$ metanix install ./cargo-checkmate
```

In this example, `metanix` detects a `Cargo.toml` so it uses `crate2nix`
to generate a nix expression in a temporary location, then it installs
the result.

## Why?

The advantage of `metanix` depends on where you're coming from:

### For Cargo Users

In order to successfully build a crate with cargo you must manually manage "system dependencies". For example, the `reqwest` crate dependes on a C compiler and `openssl` headers/libraries.

The [cargo vs metanix example](./doc/examples/cargo-vs-metanix/README.md) demonstrates this in a repeatable way with `Docker`, where a build on a debian image which has `gcc` but is missing the `openssl` dev package produces this error:

```
error: failed to run custom build command for `openssl-sys v0.9.58`

Caused by:
  process didn't exit successfully: `/usr/local/src/reqwest/target/debug/build/openssl-sys-c53ed2720f98097f/build-script-main` (exit code: 101)
```

… Then lower:

```
  --- stderr
  thread 'main' panicked at '

  Could not find directory of OpenSSL installation, and this `-sys` crate cannot
  proceed without this knowledge. If OpenSSL is installed and this crate had
  trouble finding it,  you can set the `OPENSSL_DIR` environment variable for the
  compilation process.

  Make sure you also have the development packages of openssl installed.
  For example, `libssl-dev` on Ubuntu or `openssl-devel` on Fedora.
```

-and so on.

By contrast, that example directory has a docker file that builds that crate just fine with `metanix`. This is accomplished under the hood because the standard `nixpkgs` repo provides the correct build instructions for the specific crates that need `openssl`.

### For Nix Users

Typically, `nix` users are constrained to only installing packages for which there's already a `.nix` file specifying how to build it, so if you want to build a non-nix package, you need to write your own build config.

For some package formats, though, it's possible to automatically deduce the build instructions in a way that preserves the nice `nix` guarantees we know and love. This is where `metanix` comes in: you can install/build those packages right out of the box without needing to "nixify" them first, because `metanix` nixifies on the fly.

## Status

This is a proof-of-concept prototype.

## Supported Package Types

So far I've only tested this on a handful of rust crates. If you'd like
to add support for more packages, please submit PRs.
