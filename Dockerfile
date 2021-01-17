# SPDX-License-Identifier: MIT

###############################################################################
# BUILD STAGE
###############################################################################
# docker.io/library/alpine:3.12.0
FROM alpine@sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321 AS builder

ARG CURL_VERSION=7.69.1-r1
ARG BATS_CORE_VERSION=1.2.1
ARG BATS_SUPPORT_VERSION=0.3.0
ARG BATS_ASSERT_VERSION=0.3.0
ARG BATS_FILE_VERSION=0.2.0

RUN apk --no-cache add curl=${CURL_VERSION}

WORKDIR /tmp
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]
RUN curl -fsSL https://github.com/bats-core/bats-core/archive/v${BATS_CORE_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-support/archive/v${BATS_SUPPORT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-assert/archive/v${BATS_ASSERT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-file/archive/v${BATS_FILE_VERSION}.tar.gz | tar xzv

###############################################################################
# FINAL IMAGE
###############################################################################
# docker.io/library/alpine:3.12.0
FROM alpine@sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321

ARG BASH_VERSION=5.0.17-r0
ARG PARALLEL_VERSION=20200522-r0
ARG NCURSES_VERSION=6.2_p20200523-r0

RUN set -eu; \
    apk --no-cache add bash=${BASH_VERSION} parallel=${PARALLEL_VERSION} ncurses=${NCURSES_VERSION}; \
    mkdir -p ~/.parallel; \
    touch ~/.parallel/will-cite

COPY --from=builder /tmp/bats-core-* /opt/bats-core
COPY --from=builder /tmp/bats-support-* /opt/bats-support
COPY --from=builder /tmp/bats-assert-* /opt/bats-assert
COPY --from=builder /tmp/bats-file-* /opt/bats-file
RUN ln -s /opt/bats-core/bin/bats /usr/local/bin/bats

ARG BUILD_DATE
ARG BUILD_VERSION

LABEL org.opencontainers.image.authors="Felix Furrer" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.description="TAP-compliant testing framework for Bash." \
    org.opencontainers.image.documentation="https://github.com/ffurrer2/docker-bats/blob/main/README.md" \
    org.opencontainers.image.licenses="MIT AND CC0-1.0" \
    org.opencontainers.image.source="https://github.com/ffurrer2/docker-bats.git" \
    org.opencontainers.image.title="Bash Automated Testing System" \
    org.opencontainers.image.url="https://github.com/ffurrer2/docker-bats" \
    org.opencontainers.image.vendor="Felix Furrer" \
    org.opencontainers.image.version="${BUILD_VERSION}"

WORKDIR /workdir

ENTRYPOINT ["/usr/local/bin/bats"]
CMD ["--help"]
