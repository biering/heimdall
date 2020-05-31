#!/bin/sh

STAKEPOOLS_DIR=./stakepools

read -p "Your github username: "  GITHUB_USERNAME

echo "Select stakepool you want to publish:"
for file in "$STAKEPOOLS_DIR"/*
do
  echo "- $(basename "$file")"
done

read -p "Stakepool id: "  STAKEPOOL_ID

STAKEPOOL_DIR=stakepools/$STAKEPOOL_ID/
STAKEPOOL_TICKER=`cat $STAKEPOOL_DIR/ticker.txt`
OWNER_PUB=`cat $STAKEPOOL_DIR/owner.pub`

git clone https://github.com/cardano-foundation/incentivized-testnet-stakepool-registry.git
cd incentivized-testnet-stakepool-registry/registry && git checkout -b $STAKEPOOL_TICKER
mkdir $OWNER_PUB/
cp ../../$STAKEPOOL_DIR/$OWNER_PUB.json ./
cp ../../$STAKEPOOL_DIR/$OWNER_PUB.sig ./
#cp ../../OWNER_PUBKEY.* ./
#git add *
#git commit -m "$STAKEPOOL_TICKER"
#git push --set-upstream origin $STAKEPOOL_TICKER