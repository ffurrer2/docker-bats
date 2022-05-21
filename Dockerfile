# SPDX-License-Identifier: MIT

###############################################################################
# BUILD STAGE
###############################################################################
FROM docker.io/library/alpine:3.15.4 AS builder

ARG CURL_VERSION=7.80.0-r1
# https://github.com/bats-core/bats-core/releases/latest
ARG BATS_CORE_VERSION=1.6.1
# https://github.com/ztombol/bats-support/releases/latest
ARG BATS_SUPPORT_VERSION=0.3.0
# https://github.com/ztombol/bats-assert/releases/latest
ARG BATS_ASSERT_VERSION=0.3.0
# https://github.com/ztombol/bats-file/releases/latest
ARG BATS_FILE_VERSION=0.2.0

RUN apk --no-cache add curl=${CURL_VERSION}

WORKDIR /tmp
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]
RUN curl -fsSL https://github.com/bats-core/bats-core/archive/v${BATS_CORE_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-support/archive/v${BATS_SUPPORT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-assert/archive/v${BATS_ASSERT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-file/archive/v${BATS_FILE_VERSION}.tar.gz | tar xzv; \
    # TODO: workaround for error: buildx failed with: error: failed to solve: failed to compute cache key: "/tmp/bats-core-1.5.0/test/fixtures/parallel/helper.bash": not found
    rm /tmp/bats-core-*/test/fixtures/parallel/suite/helper.bash

###############################################################################
# FINAL IMAGE
###############################################################################
FROM docker.io/library/alpine:3.15.4

ARG BASH_VERSION=5.1.16-r0
ARG PARALLEL_VERSION=20211122-r0
ARG NCURSES_VERSION=6.3_p20211120-r0

RUN set -eu; \
    apk --no-cache add bash=${BASH_VERSION} parallel=${PARALLEL_VERSION} ncurses=${NCURSES_VERSION}; \
    mkdir -p ~/.parallel; \
    touch ~/.parallel/will-cite

COPY --from=builder /tmp/bats-core-* /opt/bats-core
COPY --from=builder /tmp/bats-support-* /opt/bats-support
COPY --from=builder /tmp/bats-assert-* /opt/bats-assert
COPY --from=builder /tmp/bats-file-* /opt/bats-file
RUN ln -s /opt/bats-core/bin/bats /usr/local/bin/bats

WORKDIR /workdir

ENTRYPOINT ["/usr/local/bin/bats"]
CMD ["--help"]
