FROM debian:10@sha256:79f0b1682af1a6a29ff63182c8103027f4de98b22d8fb50040e9c4bb13e3de78

# Install Basic Debian packages to bootstrap rust:
ENV DEBS build-essential curl git

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

# Install Rust:
RUN curl https://sh.rustup.rs -sSf -o rustup.sh
RUN sh rustup.sh -y

# Now checkout and build `reqwest`:
RUN git clone 'https://github.com/seanmonstar/reqwest'
RUN cd ./reqwest && $HOME/.cargo/bin/cargo build
