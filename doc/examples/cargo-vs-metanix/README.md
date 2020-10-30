# docker vs metanix

This directory has two subdirectories with basic Dockerfiles. Using `docker` is a way to help clarify the system state for users who aren't familiar with `nix` (which already does this).

To reproduce the example behavior run `docker build` in each directory.

The [cargo-failure-example Dockerfile](./cargo-failure-example/Dockerfile) shows a typical approach to building the `reqwest` crate on a Debian system. The build fails because the debian dependency for `openssl` libraries is not present and `cargo` doesn't know how to handle that.

The [metanix-success-example Dockerfile](./metanix-success-example/Dockerfile) shows the straightforward flow of building the same crate with `metanix`.
