#!/bin/sh

STAKEPOOL_TICKER=`cat ticker.txt | tr '[:upper:]' '[:lower:]'`
DOCKER_NAME="stakepool-$STAKEPOOL_TICKER"
docker build -t "$DOCKER_NAME" ./operator
