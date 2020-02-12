FROM alpine:latest AS builder

RUN apk update && apk add curl && apk add --no-cache --upgrade grep
RUN adduser -D -g '' appuser

RUN curl https://api.github.com/repos/turtlecoin/turtlecoin/tags -O
RUN ENV TAGS=`cat tags | grep -i ["name"] | grep -oh -P '(v\d+.\d+.\d+)'`
RUN curl https://github.com/turtlecoin/turtlecoin/releases/latest/download/turtlecoin-linux-"$TAGS"-tar.gz
RUN tar -C /turtlecoin -zxvf turtlecoin-linux-"$TAGS"-tar.gz
RUN cd /turtlecoin

FROM scratch
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /etc/passwd /etc/passwd
USER appuser
ENTRYPOINT ["/turtlecoin"]