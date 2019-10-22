FROM golang as builder

RUN go get -d github.com/google/cadvisor

WORKDIR $GOPATH/src/github.com/google/cadvisor

RUN make build

FROM debian:buster-slim

# Grab cadvisor from the staging directory.
COPY --from=builder /go/src/github.com/google/cadvisor /usr/bin/

# EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/healthz || exit 1

ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]