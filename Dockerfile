#
# builder image
#
FROM golang:1.21 AS builder
RUN mkdir /build
ADD src/* /build/
WORKDIR /build

# create module, fetch dependencies, then build
RUN go mod download && go mod verify

RUN CGO_ENABLED=0 GOOS=linux go build main.go


#
# generate small final image for end users
#
FROM alpine:3.13.5

# copy golang binary into container
WORKDIR /root
COPY --from=builder /build/main .

# executable
ENTRYPOINT [ "./main" ]