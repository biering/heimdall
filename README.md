# Setup your own Stake Pool

## (1) Install Ubuntu (I'm using Ubuntu ...)


### Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH="$HOME/.cargo/bin:$PATH"
rustup install stable
rustup default stable
```

### Install Docker & docker-compose

```bash
sudo apt-get update
sudo apt-get install docker-compose
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io

sudo systemctl start docker
sudo systemctl enable docker
```

## (2) Install Daedalus Reward Wallet (https://staking.cardano.org/en/delegation/)

### On Linux

```bash
chmod a+x name_of_file.bin
./name_of_file.bin
```


## (4) Install Jormunder

```bash
git clone --recurse-submodules https://github.com/input-output-hk/jormungandr
cd jormungandr
git checkout tags/<latest release tag> # replace this with something like v0.8.18
git submodule update
cargo install --locked --path jormungandr # --features systemd # (on linux with systemd)
cargo install --locked --path jcli
```


## (5) Install Cardano Wallet

```bash
wget https://raw.githubusercontent.com/input-output-hk/cardano-wallet/master/docker-compose.yml
NETWORK=testnet docker-compose up #sudo
``` 