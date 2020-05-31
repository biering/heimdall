#!/bin/sh

./jcli key generate --type ed25519 | tee owner.prv | ./jcli key to-public > owner.pub
./jcli address account --testing --prefix addr `cat owner.pub` > owner.addr

OWNER_PRIV_KEY=`cat ./owner.prv`
OWNER_PUB_KEY=`cat ./owner.pub`
OWNER_ADDR=`cat ./owner.addr`

echo ">>> Creating Stake Pool: $STAKEPOOL_NAME (TAX_VALUE=$TAX_VALUE, TAX_RATIO=$TAX_RATIO) ..."
./createStakePool.sh $REST_PORT $TAX_VALUE $TAX_RATIO $OWNER_PRIV_KEY | tee results.txt

echo "$STAKEPOOL_TICKER" > ticker.txt

jq -n --arg ownerpub "$OWNER_PUB_KEY" \
--arg spname "$STAKEPOOL_NAME" \
--arg spdescription "$STAKEPOOL_DESCRIPTION" \
--arg spticker "$STAKEPOOL_TICKER" \
--arg spwebsite "$STAKEPOOL_WEBSITE" \
--arg owneraddr "$OWNER_ADDR" '{owner: $ownerpub, name: $spname, description: $spdescription, ticker: $spticker, homepage: $spwebsite, pledge_address: $owneraddr}' > $OWNER_PUB_KEY.json

./jcli key sign --secret-key owner.prv --output $OWNER_PUB_KEY.sig $OWNER_PUB_KEY.json
./jcli key verify --public-key owner.pub --signature $OWNER_PUB_KEY.sig $OWNER_PUB_KEY.json