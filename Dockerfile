# SPDX-License-Identifier: MIT

###############################################################################
# BUILD STAGE
###############################################################################
FROM alpine:latest AS builder

RUN apk --no-cache add curl

ARG BATS_CORE_VERSION=1.2.0
ARG BATS_SUPPORT_VERSION=0.3.0
ARG BATS_ASSERT_VERSION=0.3.0
ARG BATS_FILE_VERSION=0.2.0

WORKDIR /tmp
RUN set -euxo pipefail; \
    curl -fsSL https://github.com/bats-core/bats-core/archive/v${BATS_CORE_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-support/archive/v${BATS_SUPPORT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-assert/archive/v${BATS_ASSERT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-file/archive/v${BATS_FILE_VERSION}.tar.gz | tar xzv

###############################################################################
# FINAL IMAGE
###############################################################################
FROM alpine:latest

RUN apk --no-cache add bash parallel && \
    mkdir -p ~/.parallel && \
    touch ~/.parallel/will-cite

COPY --from=builder /tmp/bats-core-* /opt/bats-core
COPY --from=builder /tmp/bats-support-* /opt/bats-support
COPY --from=builder /tmp/bats-assert-* /opt/bats-assert
COPY --from=builder /tmp/bats-file-* /opt/bats-file
RUN ln -s /opt/bats-core/bin/bats /usr/local/bin/bats

ARG BUILD_DATE

LABEL org.opencontainers.image.authors="Felix Furrer" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.description="TAP-compliant testing framework for Bash." \
    org.opencontainers.image.documentation="https://github.com/ffurrer2/docker-bats/blob/master/README.md" \
    org.opencontainers.image.licenses="MIT AND CC0-1.0" \
    org.opencontainers.image.source="https://github.com/ffurrer2/docker-bats.git" \
    org.opencontainers.image.title="Bash Automated Testing System" \
    org.opencontainers.image.url="https://github.com/ffurrer2/docker-bats" \
    org.opencontainers.image.vendor="Felix Furrer" \
    org.opencontainers.image.version="${BATS_CORE_VERSION}"

WORKDIR /workdir

ENTRYPOINT ["/usr/local/bin/bats"]
CMD [ "--help" ]
