FROM alpine:latest AS builder

RUN apk update && apk add curl && apk add --no-cache --upgrade grep
RUN adduser -D -g '' appuser

RUN curl https://api.github.com/repos/turtlecoin/turtlecoin/tags -O
RUN TAGS=$(cat tags | grep -m1 -i ["name"] | grep -oh -P '(v\d+.\d+.\d+)') | curl https://github.com/turtlecoin/turtlecoin/releases/download/"$TAGS"/turtlecoin-linux-"$TAGS"-tar.gz | tar -C /turtlecoin -zxvf turtlecoin-linux-"$TAGS"-tar.gz
RUN cd /turtlecoin
RUN curl https://blockapi.turtlepay.io/checkpointsIPFSHash
RUN HASH=$(cat tags | grep -i ["hash"] | grep -oh -P '([A-Z])\w+')
RUN curl https://cloudflare-ipfs.com/ipfs/"$HASH" > checkpoint.csv

FROM scratch
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /etc/passwd /etc/passwd
USER appuser
ENTRYPOINT ["/turtlecoin"]