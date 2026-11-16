#!/bin/bash
# Copyright 2025 Hedgehog
# SPDX-License-Identifier: Apache-2.0

set -eux
set -o pipefail

RUNTIME_APT_PACKAGES=(
    curl
    dhcping
    ethtool
    gdb
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
    dmidecode
    ca-certificates
    tshark
    perftest
    lm-sensors
    mstflint
    btop
    bind9-dnsutils
    lsof
    tmux
    strace
    ltrace
    arping
    cpio
    telnet
    jq
    less
    xz-utils
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

# cpio instead of tar: 26.04's tar fails with ENOSYS under amd64 emulation (e.g. Apple Silicon)
CLOUDFLARE_SPEED_CLI_VERSION=v0.6.6
CLOUDFLARE_SPEED_CLI_ARCHIVE=cloudflare-speed-cli-x86_64-unknown-linux-musl.tar.xz
CLOUDFLARE_SPEED_CLI_BASE_URL=https://github.com/kavehtehrani/cloudflare-speed-cli/releases/download/${CLOUDFLARE_SPEED_CLI_VERSION}
curl -fsSLO "${CLOUDFLARE_SPEED_CLI_BASE_URL}/${CLOUDFLARE_SPEED_CLI_ARCHIVE}" \
    && curl -fsSLO "${CLOUDFLARE_SPEED_CLI_BASE_URL}/${CLOUDFLARE_SPEED_CLI_ARCHIVE}.sha256" \
    && sha256sum -c "${CLOUDFLARE_SPEED_CLI_ARCHIVE}.sha256" \
    && xz -dc "${CLOUDFLARE_SPEED_CLI_ARCHIVE}" | cpio -idm --quiet \
    && install -m 0755 cloudflare-speed-cli-x86_64-unknown-linux-musl/cloudflare-speed-cli /usr/local/bin/cloudflare-speed-cli \
    && rm -rf cloudflare-speed-cli-x86_64-unknown-linux-musl*
