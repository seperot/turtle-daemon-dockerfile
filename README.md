# TurtleCoin Daemon Dockerfile
Dockerfile that spins up the latest turtlecoin daemon with the latest checkpoint added in

## Build it yourself
`docker build --build-arg TAGS=<"Version"> --build-arg CHECKPOINT=<Checkpoint Hash> -t ijhdev/turtlecoin-daemon .`

#### You can get the releases from here:
https://github.com/turtlecoin/turtlecoin/releases  

#### You can get the latest hash from here:
http://checkpoints.turtlecoin.lol/  

## Use the premade image
`docker pull ijhdev/turtlecoin-daemon`

## Run the Image
`docker run ijhdev/turtlecoin-daemon`

## Run the Daemon
`./turtlecoin/main/TurtleCoind --load-checkpoints turtlecoin/main/checkpoint.csv`

### Trying to figure out how to get the daemon to start in the background but so far no luck.
