FROM debian:10@sha256:79f0b1682af1a6a29ff63182c8103027f4de98b22d8fb50040e9c4bb13e3de78

# Install Basic Debian packages to bootstrap nix:
ENV DEBS curl sudo xz-utils

RUN DEBIAN_FRONTEND=noninteractive \
      apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
      apt-get install -qq \
        $DEBS

# Set up dev user:
ENV USER devuser
RUN adduser --gecos '' --disabled-password $USER
RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers
WORKDIR /home/$USER
USER $USER
SHELL ["/bin/bash", "--login", "-c"]

# Install nix:
RUN curl https://nixos.org/nix/install -L -o install-nix.sh
RUN sh install-nix.sh --no-daemon

# Install metanix and git:
RUN nix-env -i git
RUN nix-env -if 'https://github.com/nathan-at-least/metanix/tarball/reqwest-docker-examples'

# Now checkout and build `reqwest`:
RUN git clone 'https://github.com/seanmonstar/reqwest'
RUN metanix build ./reqwest
