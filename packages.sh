#!/bin/bash

set -eux
set -o pipefail

APT_PACKAGES=(
    curl
    dhcping
    ethtool
    iperf3
    iproute2
    iputils-ping
    net-tools
    openssh-client
    socat
    tcpdump
    wget
)

apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    "${APT_PACKAGES[@]}" \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*
