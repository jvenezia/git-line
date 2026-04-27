# syntax=docker/dockerfile:1

FROM debian:bookworm-slim AS dev

ARG DEBIAN_FRONTEND=noninteractive
ARG BATS_VERSION=1.13.0
ARG BATS_SUPPORT_VERSION=0.3.0
ARG BATS_ASSERT_VERSION=2.2.4
ARG SHELLCHECK_VERSION=0.9.0-1
ARG SHFMT_VERSION=3.6.0-1+b2

ENV BATS_LIB_PATH=/usr/local/lib/bats

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    git \
    parallel \
    shellcheck="${SHELLCHECK_VERSION}" \
    shfmt="${SHFMT_VERSION}" \
  && rm -rf /var/lib/apt/lists/*

RUN git -c advice.detachedHead=false clone --depth 1 --branch "v${BATS_VERSION}" https://github.com/bats-core/bats-core.git /tmp/bats-core \
  && /tmp/bats-core/install.sh /usr/local \
  && rm -rf /tmp/bats-core

RUN mkdir -p "${BATS_LIB_PATH}" \
  && git -c advice.detachedHead=false clone --depth 1 --branch "v${BATS_SUPPORT_VERSION}" https://github.com/bats-core/bats-support.git "${BATS_LIB_PATH}/bats-support" \
  && git -c advice.detachedHead=false clone --depth 1 --branch "v${BATS_ASSERT_VERSION}" https://github.com/bats-core/bats-assert.git "${BATS_LIB_PATH}/bats-assert"

WORKDIR /app

CMD ["bats", "test/scripts"]
