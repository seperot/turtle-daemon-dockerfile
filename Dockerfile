FROM alpine:latest AS builder

RUN apk update && apk add curl && apk add --no-cache --upgrade grep
RUN adduser -D -g '' appuser

RUN curl https://api.github.com/repos/turtlecoin/turtlecoin/tags -O
RUN mkdir turtlecoin
RUN echo $'TAGS=`cat tags | grep -m1 -i ["name"] | grep -oh -P (v\d+.\d+.\d+)` \n\ curl https://github.com/turtlecoin/turtlecoin/releases/download/"$TAGS"/turtlecoin-linux-"$TAGS"-tar.gz \n\ mkdir turtlecoin && tar -C /turtlecoin -zxvf turtlecoin-linux-"$TAGS"-tar.gz'
RUN cd turtlecoin
RUN curl https://blockapi.turtlepay.io/checkpointsIPFSHash
RUN echo $'HASH=`cat checkpointsIPFSHash | grep -i ["hash"] | grep -oh -P ([A-Z])\w+)` \n\ curl https://cloudflare-ipfs.com/ipfs/"$HASH"' > checkpoint.csv
RUN cd turtlecoin | ls

FROM scratch
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /etc/passwd /etc/passwd
USER appuser
ENTRYPOINT ["/turtlecoin"] 