# SPDX-License-Identifier: MIT

###############################################################################
# BUILD STAGE
###############################################################################
# docker.io/library/alpine:3.14.2
FROM alpine@sha256:e1c082e3d3c45cccac829840a25941e679c25d438cc8412c2fa221cf1a824e6a AS builder

ARG CURL_VERSION=7.79.1-r0
ARG BATS_CORE_VERSION=1.3.0
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
# docker.io/library/alpine:3.14.2
FROM alpine@sha256:e1c082e3d3c45cccac829840a25941e679c25d438cc8412c2fa221cf1a824e6a

ARG BASH_VERSION=5.1.4-r0
ARG PARALLEL_VERSION=20210522-r0
ARG NCURSES_VERSION=6.2_p20210612-r0

RUN set -eu; \
    apk --no-cache add bash=${BASH_VERSION} parallel=${PARALLEL_VERSION} ncurses=${NCURSES_VERSION}; \
    mkdir -p ~/.parallel; \
    touch ~/.parallel/will-cite

COPY --from=builder /tmp/bats-core-* /opt/bats-core
COPY --from=builder /tmp/bats-support-* /opt/bats-support
COPY --from=builder /tmp/bats-assert-* /opt/bats-assert
COPY --from=builder /tmp/bats-file-* /opt/bats-file
RUN ln -s /opt/bats-core/bin/bats /usr/local/bin/bats

ARG BUILD_DATE="1970-01-01T00:00:00Z"
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
