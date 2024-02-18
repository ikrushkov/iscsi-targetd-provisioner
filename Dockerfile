#
# builder image
#
FROM golang:1.21 AS builder

RUN mkdir /build

COPY src/. /build/

WORKDIR /build/

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

# fetch dependencies, then build
RUN go mod download && go mod verify

RUN go build -o iscsi-provisioner

#
# generate small final image for end users
#
FROM alpine:3.13.5

# copy golang binary into container
WORKDIR /root
COPY --from=builder /build/iscsi-provisioner .

# executable
ENTRYPOINT [ "./iscsi-provisioner" ]