FROM ubuntu:jammy

RUN --mount=type=bind,source=packages.sh,target=/tmp/packages.sh /tmp/packages.sh