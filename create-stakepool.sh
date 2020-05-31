#!/bin/sh

read -p "Stake pool name: "  STAKEPOOL_NAME
read -p "Stake pool description: "  STAKEPOOL_DESCRIPTION
read -p "Ticker Symbol: "  STAKEPOOL_TICKER
read -p "Website URL: "  STAKEPOOL_WEBSITE
read -p "Tax Value (e.g. 2000000 == 2 ADA): "  TAX_VALUE
read -p "Tax Ratio (e.g. 2/100 == 2%): "  TAX_RATIO

#if [ $# -ne 4 ]; then
#    echo "usage: $0 <REST-LISTEN-PORT> <TAX_VALUE> <TAX_RATIO> <ACCOUNT_SK>"
#    echo "    <REST-LISTEN-PORT>   The REST Listen Port set in node-config.yaml file (EX: 3101)"
#    echo "    <TAX_VALUE>   The fixed cut the stake pool will take from the total reward"
#    echo "    <TAX_RATIO>   The percentage of the remaining value that will be taken from the total (EX: '1/10')"
#    echo "    <SOURCE-SK>   The Secret key of the Source address"
#    exit 1
#fi

# create docker container with env variables
id=$(docker create -i -t \
    -e "STAKEPOOL_NAME=$STAKEPOOL_NAME" \
    -e "STAKEPOOL_DESCRIPTION=$STAKEPOOL_DESCRIPTION" \
    -e "STAKEPOOL_TICKER=$STAKEPOOL_TICKER" \
    -e "STAKEPOOL_WEBSITE=$STAKEPOOL_WEBSITE" \
    -e "TAX_VALUE=$TAX_VALUE" \
    -e "TAX_RATIO=$TAX_RATIO" \
    heimdall_creator)
docker start -a $id

# copy from docker container to host
cd creator
mkdir ./temp
TEMP=./temp
docker cp $id:/home/creator/ - > $TEMP/output.tar.gz
cd $TEMP && tar -xzf ./output.tar.gz && cd ..

# copy files from docker container copy
cp $TEMP/creator/owner.prv $TEMP/
cp $TEMP/creator/owner.pub $TEMP/
cp $TEMP/creator/owner.addr $TEMP/
cp $TEMP/creator/results.txt $TEMP/
cp $TEMP/creator/node_secret.yaml $TEMP/
cp $TEMP/creator/stake_pool.id $TEMP/
cp $TEMP/creator/ticker.txt $TEMP/

OWNER_ADDR=`cat $TEMP/owner.addr`
OWNER_PUB=`cat $TEMP/owner.pub`
STAKEPOOL_TICKER=`cat $TEMP/ticker.txt`
STAKEPOOL_DIR="stakepool-$STAKEPOOL_TICKER"

# create registry dictionary
mkdir $TEMP/registry/
mkdir $TEMP/registry/$OWNER_PUB/
cp $TEMP/creator/$OWNER_PUB.json $TEMP/registry/$OWNER_PUB/
cp $TEMP/creator/$OWNER_PUB.sig $TEMP/registry/$OWNER_PUB/

# copy to final dictionary and remove tmp files
rm -rf $TEMP/creator
rm $TEMP/output.tar.gz
mkdir ../stakepools/$STAKEPOOL_DIR
cp -r $TEMP/. ../stakepools/$STAKEPOOL_DIR/
rm -rf $TEMP/
cd ..

# stop docker
docker rm -v $id

# create stakepool operator
cp -r creator/operator/. stakepools/$STAKEPOOL_DIR/
mkdir stakepools/$STAKEPOOL_DIR/operator/
cp -r operator/. stakepools/$STAKEPOOL_DIR/operator/
cp stakepools/$STAKEPOOL_DIR/node_secret.yaml stakepools/$STAKEPOOL_DIR/operator/