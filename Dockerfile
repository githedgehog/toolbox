# Copyright 2025 Hedgehog
# SPDX-License-Identifier: Apache-2.0

FROM ubuntu:noble

RUN --mount=type=bind,source=packages.sh,target=/tmp/packages.sh /tmp/packages.sh

WORKDIR /
COPY --chown=0:0 ./bin/echo /bin/
