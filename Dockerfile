FROM ubuntu:latest AS builder

RUN apt-get update && apt-get -y upgrade && apt-get -y install curl && rm -rf /var/cache/apk/*
WORKDIR /app
COPY ./docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh /

ARG TAGS=v0.22.0
RUN curl -L https://github.com/turtlecoin/turtlecoin/releases/download/"$TAGS"/turtlecoin-linux-"$TAGS".tar.gz > file.tar.gz
run mkdir turtlecoin
RUN tar -zxvf file.tar.gz -C turtlecoin
RUN rm file.tar.gz
ARG CHECKPOINT=QmSRrivVW1gArTE6S4Rxh66MAkvUK7UNscaMn4KwEjcW9x
RUN curl -L https://ipfs.io/ipfs/"$CHECKPOINT" > turtlecoin/turtlecoin-"$TAGS"/checkpoint.csv
RUN ls

RUN mv turtlecoin/turtlecoin-"$TAGS" turtlecoin/main

ENTRYPOINT ["docker-entrypoint.sh"]
