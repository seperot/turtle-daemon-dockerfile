FROM alpine:latest AS builder

RUN apk update && apk add curl && apk add --no-cache --upgrade grep && apk add --no-cache --upgrade bash
RUN adduser -D -g '' appuser

RUN curl -L https://github.com/turtlecoin/turtlecoin/releases/download/v0.22.0/turtlecoin-linux-v0.22.0.tar.gz > file.tar.gz
RUN tar -zxvf file.tar.gz
RUN curl -L https://cloudflare-ipfs.com/ipfs/QmW6a6VvX43vfJNktHs9ycZJtCqLJfZLwHWsxQmF7EyiV6 > turtlecoin-v0.22.0/checkpoint.csv

FROM scratch
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /etc/passwd /etc/passwd
USER appuser
ENTRYPOINT ["/turtlecoin"]