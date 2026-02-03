#!/bin/bash
# Copyright 2025 Hedgehog
# SPDX-License-Identifier: Apache-2.0

set -eux
set -o pipefail

RUNTIME_APT_PACKAGES=(
    curl
    dhcping
    ethtool
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
    pciutils
    ca-certificates
    tshark
    perftest
    ethtool
    lm-sensors
    mstflint
    btop
    dnsutils
    lsof
    tmux
    strace
    ltrace
    arping
    cpio
    telnet
    jq
    less
)

apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
    "${RUNTIME_APT_PACKAGES[@]}" \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/
