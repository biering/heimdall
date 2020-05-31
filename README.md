![Heimdall Logo](assets/heimdall-logo-title.png "Heimdall Logo")

# Setup your own Cardano Stake Pool

Goals of **Heimdall**:
* Everyone should have the opportunity to operate a stake pool.
* Maintaining a stake pool should be as easy as possible. Things that can be automated should be automated.
* Operating system independent creation of stake pools.
* Discussion base to find the optimal configuration and to collect knowledge.

## Create a Stakepool

If you already have one and just want to operate it, you can skip this step.

1. Install Docker [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)
2. Create creator docker image `./make-creator.sh`. You only need to run this script when you change something at the creator (e.g. updating the repository).
3. Create stake pool with `./create-stakepool.sh`. The script will guide you through the process to define the stake pool configuration. The created stake pool will be stored under `stakepools/stakepool-<TICKER>`.
4. Upload to the [incentivized-testnet-stakepool](https://github.com/cardano-foundation/incentivized-testnet-stakepool-registry/) registry. There you need to add the created dictionary under `stakepools/stakepool-<TICKER>/registry/` and create a pull request.

|File              |Description                                                                                                                                                                     |
|:-----------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`operator/`       |Blueprint to create and use the operator docker image.                                                                                                                          |
|`registry/`       |If you create a stakepool you need to register the contents at [incentivized-testnet-stakepool](https://github.com/cardano-foundation/incentivized-testnet-stakepool-registry/).|
|`node_secret.yaml`|Needed to run the stake pool.                                                                                                                                                   |
|`owner.pub`       |The owner wallet public key.                                                                                                                                                    |
|`owner.prv`       |The owner wallet private key. Never share.                                                                                                                                      |
|`owner.addr`      |The owner wallet address.                                                                                                                                                       |
|`stake_pool.id`   |The stake pool id.                                                                                                                                                              |

## Operate a Stakepool

After you created a stakepool you can also operate it with Heimdall.

1. Install docker-compose ([https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/))
2. Build the operator docker image with `cd stakepools/stakepool-<TICKER> && ./build-operator.sh`
3. Replace `<YOUR_DOCKER_IMAGE>` in `docker-compose.yaml` with the name of your created docker image.
4. Start the stakepool with `docker-compose up`

Now the stakepool is running. You can check the status with `./jcli rest v0 node stats get --host "http://127.0.0.1:3100/api"`.

## Useful Links

- [How Cardano pool operator fees work](https://forum.cardano.org/t/how-cardano-pool-operator-fees-work/29348)

This project was heavily inspired by [organicdesign.com](https://www.organicdesign.com.br/Set_up_a_Cardano_staking_pool).