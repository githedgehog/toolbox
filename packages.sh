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
    screen
    socat
    tcpdump
    traceroute
    wget
    vim
    curl
    wget
    pciutils
)

apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    "${APT_PACKAGES[@]}" \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
