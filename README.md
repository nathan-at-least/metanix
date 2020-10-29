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

`nix` is excellent at nailing down wiggly build & runtime dependencies
across a large variety of development toolchains. For some toolchains,
like Cargo, however, the transitive dependencies are often already fully
well specified and tools can automatically generate the appropriate nix
expressions. In these cases, `metanix` can install the target package
without needing explicit nix files from upstream developers or package
maintainers.

## Status

This is a proof-of-concept prototype.

## Supported Package Types

So far I've only tested this on a handful of rust crates. If you'd like
to add support for more packages, please submit PRs.
