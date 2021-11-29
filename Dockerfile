FROM --platform=$BUILDPLATFORM golang:1.17.3-alpine3.13 as builder
LABEL version="$(cat VERSION)"
ARG TARGETARCH
ENV GOARCH=$TARGETARCH
RUN go get github.com/jovalle/pihole-exporter && \
  cd /go/src/github.com/jovalle/pihole-exporter && \
  make build

FROM scratch
LABEL name="pihole-exporter"
LABEL version="$(cat VERSION)"
COPY --from=builder /go/src/github.com/jovalle/pihole-exporter/binary /pihole-exporter
EXPOSE 9617
CMD ["/pihole-exporter"]