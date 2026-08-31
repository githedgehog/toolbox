#!/bin/bash
# Copyright 2025 Hedgehog
# SPDX-License-Identifier: Apache-2.0

set -eux
set -o pipefail

BUILD_APT_PACKAGES=(
    ca-certificates
    git
    build-essential
    libtool
    autoconf
    automake
    pkg-config
)

apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    "${BUILD_APT_PACKAGES[@]}" \
    && rm -rf /var/lib/apt/lists/*

git clone --branch 3.21 https://github.com/esnet/iperf.git /tmp/iperf \
    && cd /tmp/iperf \
    && sed -i 's/j = JSON_read(test->ctrl_sck, 0);/j = JSON_read(test->ctrl_sck, 1024 * 1024);/' src/iperf_api.c \
    && grep -q 'JSON_read(test->ctrl_sck, 1024 \* 1024)' src/iperf_api.c \
    && ./configure \
    && make \
    && make install \
    && cd /
