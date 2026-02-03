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

git clone https://github.com/esnet/iperf.git /tmp/iperf \
    && cd /tmp/iperf \
    && ./configure \
    && make \
    && make install \
    && cd /
