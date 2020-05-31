FROM ubuntu:20.04
WORKDIR /home/node

ARG DEBIAN_FRONTEND=noninteractive

RUN export TZ=Europe/Berlin

# install ubuntu dependencies
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    curl \
    git \
    pkg-config \
    libssl-dev \
    systemd \
    unzip \
    wget \
    zlib1g-dev \
    nano \
    file \
    sudo \
    protobuf-compiler \
    python-pil \
    python-lxml \
    python-tk \
    htop \
    jq \
    libwww-perl \
    libjson-perl \
    chrony

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
ENV PATH="${PATH}:${HOME}/.cargo/bin"

# install jormungandr
#RUN git clone --recurse-submodules https://github.com/input-output-hk/jormungandr
#RUN cd jormungandr
#RUN cd jormungandr && git checkout tags/v0.8.18 # replace this with something like v0.8.18
#RUN cd jormungandr && git submodule update
#RUN cd jormungandr && cargo install --locked --path jormungandr # --features systemd # (on linux with systemd)
#RUN cd jormungandr && cargo install --locked --path jcli

RUN wget https://github.com/input-output-hk/jormungandr/releases/download/v0.8.18/jormungandr-v0.8.18-x86_64-unknown-linux-gnu-generic.tar.gz
RUN tar -xzf jormungandr-v0.8.18-x86_64-unknown-linux-gnu-generic.tar.gz

RUN wget https://github.com/input-output-hk/cardano-wallet/releases/download/v2020-05-06/cardano-wallet-itn-v2020-05-06-linux64.tar.gz
RUN tar -xzf cardano-wallet-itn-v2020-05-06-linux64.tar.gz
RUN cp ./cardano-wallet-jormungandr-linux64/cardano-wallet .

COPY ./node_secret.yaml /home/node/
COPY ./itn_rewards_v1-config.yaml /home/node/
COPY ./genesis-hash.txt /home/node/
COPY ./cardano-update-conf.pl /home/node/
COPY ./start.sh /home/node/


EXPOSE 3000
EXPOSE 3100
ENTRYPOINT ["/bin/bash", "./start.sh"]