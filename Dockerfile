FROM ubuntu:20.04
WORKDIR /home/stakepool

ARG DEBIAN_FRONTEND=noninteractive

COPY shell/install-jormungandr.sh /home/stakepool/shell/

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
    file
RUN apt-get install protobuf-compiler python-pil python-lxml python-tk -y
RUN apt-get install -y docker.io docker-compose

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"
ENV PATH="${PATH}:${HOME}/.cargo/bin"

# install jormungandr
RUN git clone --recurse-submodules https://github.com/input-output-hk/jormungandr
RUN cd jormungandr
RUN cd jormungandr && git checkout tags/v0.8.18 # replace this with something like v0.8.18
RUN cd jormungandr && git submodule update
RUN cd jormungandr && cargo install --locked --path jormungandr # --features systemd # (on linux with systemd)
RUN cd jormungandr && cargo install --locked --path jcli

# RUN /home/stakepool/shell/install-jormungandr.sh

#CMD [ "bash" ]
ENTRYPOINT ["bash"]