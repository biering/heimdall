# Heimdall - Setup your own Stake Pool

Goals of **Heimdall**:
* Everyone should have the opportunity to operate a stake pool.
* Maintaining a stake pool should be as easy as possible. Things that can be automated should be automated.
* Contact point to find the optimal configuration and to collect knowledge

## Create a Stakepool

If you already have one and just want to operate it, you can skip this step.

(1) Install Docker

(2) Create Creator Docker Image

```bash
cd creator
make install
cd ..
```

(3) Create Stakepool

```bash
./create-stakepool.sh
```

The stakepool will be stored under `./stakepools/...`

(4) Upload to the registry

## Operate a Stakepool