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
mkdir ./output
docker cp $id:/home/creator/ - > ./output/output.tar.gz
cd output && tar -xzf ./output.tar.gz && cd ..

# copy files from docker container copy
cp output/creator/owner.prv output/
cp output/creator/owner.pub output/
cp output/creator/owner.addr output/
cp output/creator/results.txt output/
cp output/creator/node_secret.yaml output/
cp output/creator/stake_pool.id output/
cp output/creator/ticker.txt output/

OWNER_ADDR=`cat output/owner.addr`
OWNER_PUB=`cat output/owner.pub`
POOL_ID=`cat output/stake_pool.id`

# create registry dictionary
cp output/creator/$OWNER_PUB.json output/registry/$OWNER_PUB/
cp output/creator/$OWNER_PUB.sig output/registry/$OWNER_PUB/

# copy to final dictionary and remove tmp files
rm -rf output/creator
rm output/output.tar.gz
mkdir ../stakepools/$POOL_ID
cp -r output/. ../stakepools/$POOL_ID/
rm -rf output/

# stop docker
docker rm -v $id