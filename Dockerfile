FROM golang:1.20-alpine as builder

WORKDIR /app
RUN apk add --update nodejs npm make
RUN go install github.com/jteeuwen/go-bindata/...@latest
RUN go install github.com/tools/godep@latest

COPY backend backend
COPY Godeps Godeps
COPY js js
COPY pkg pkg
COPY resources resources
COPY server server
COPY utils utils
COPY vendor vendor
COPY webtty webtty
COPY help.go main.go version.go Makefile ./
RUN go mod init
RUN make all

FROM docker:cli
RUN apk add --update bash
COPY --from=builder /app/gotty /usr/bin/gotty
ENTRYPOINT ["gotty"]