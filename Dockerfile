FROM golang:1.13-alpine AS builder

RUN apk update && apk add --no-cache \
    make \
    git \
    tzdata \
    wget

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk
RUN apk add glibc-2.29-r0.apk

RUN mkdir -p /opt/app
WORKDIR /opt/app
COPY . .

RUN make build

FROM scratch

COPY --from=builder /opt/app/bin/helloworld /opt/app/
COPY --from=builder /opt/app/bin/ping /opt/app/