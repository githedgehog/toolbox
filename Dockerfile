# Copyright 2025 Hedgehog
# SPDX-License-Identifier: Apache-2.0

FROM ubuntu:noble AS builder
RUN --mount=type=bind,source=packages_build.sh,target=/tmp/packages_build.sh /bin/bash /tmp/packages_build.sh

FROM golang:alpine AS go_builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/bin/version ./cmd/version
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/bin/demo ./cmd/demo

FROM ubuntu:noble AS runner
RUN --mount=type=bind,source=packages_runtime.sh,target=/tmp/packages_runtime.sh /bin/bash /tmp/packages_runtime.sh

COPY --from=builder /usr/local/bin/iperf3 /usr/local/bin/iperf3
COPY --from=builder /usr/local/lib/libiperf.so* /usr/local/lib/
RUN ldconfig

WORKDIR /
COPY --chown=0:0 ./bin/version /bin/
COPY --chown=0:0 ./bin/demo /bin/
