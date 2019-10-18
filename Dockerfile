FROM golang:1.13-alpine AS builder

# Install stuff required to build the artifacts
RUN apk update && apk add --no-cache \
    # Make build automation tool
    make \
    # Git required to operate with the git repository
    git \
    # Zoneinfo for timezones
    tzdata \
    # wget to download stuff
    wget

# A glibc compatibility layer package for Alpine Linux
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk
RUN apk add glibc-2.29-r0.apk

RUN mkdir -p /opt/app
WORKDIR /opt/app
COPY . .

RUN make build

FROM scratch

# Copy binaries, one by one, to avoid copying all the other binaries created during the build process
COPY --from=builder /opt/app/bin/helloworld /opt/app/
COPY --from=builder /opt/app/bin/ping /opt/app/