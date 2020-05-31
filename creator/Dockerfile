FROM ubuntu:20.04
WORKDIR /home/creator

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
    jq

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
ENV PATH="${PATH}:${HOME}/.cargo/bin"

# install jormungandr
RUN wget https://github.com/input-output-hk/jormungandr/releases/download/v0.8.18/jormungandr-v0.8.18-x86_64-unknown-linux-gnu-generic.tar.gz
RUN tar -xzf jormungandr-v0.8.18-x86_64-unknown-linux-gnu-generic.tar.gz

# install cardano-wallet
RUN wget https://github.com/input-output-hk/cardano-wallet/releases/download/v2020-05-06/cardano-wallet-itn-v2020-05-06-linux64.tar.gz
RUN tar -xzf cardano-wallet-itn-v2020-05-06-linux64.tar.gz
RUN cp ./cardano-wallet-jormungandr-linux64/cardano-wallet .

COPY ./create.sh /home/creator/
COPY ./createStakePool.sh /home/creator/
COPY ./send-certificate.sh /home/creator/
COPY ./stakepool-config.json /home/creator/

ENV REST_PORT=3100
ENV TAX_VALUE=1000000
ENV TAX_RATIO=5/100
ENV STAKEPOOL_NAME=''
ENV STAKEPOOL_DESCRIPTION=''
ENV STAKEPOOL_TICKER=''
ENV STAKEPOOL_WEBSITE=''

ENTRYPOINT ["/bin/bash", "./create.sh"]