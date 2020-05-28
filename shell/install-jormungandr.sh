test="$1"

echo ${test}

git clone --recurse-submodules https://github.com/input-output-hk/jormungandr
cd jormungandr
git checkout tags/v0.8.18 # replace this with something like v0.8.18
git submodule update
cargo install --locked --path jormungandr # --features systemd # (on linux with systemd)
cargo install --locked --path jcli
