<!-- SPDX-License-Identifier: MIT -->
# Bats Docker image

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/ffurrer/bats)](https://hub.docker.com/r/ffurrer/bats/builds)
[![Docker Cloud Automated Build](https://img.shields.io/docker/cloud/automated/ffurrer/bats)](https://hub.docker.com/r/ffurrer/bats/builds)
[![Docker Image Version](https://img.shields.io/docker/v/ffurrer/bats?sort=semver)](https://hub.docker.com/r/ffurrer/bats/tags)
[![Docker Image Size](https://img.shields.io/docker/image-size/ffurrer/bats/latest)](https://hub.docker.com/r/ffurrer/bats/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/ffurrer/bats)](https://hub.docker.com/r/ffurrer/bats)

This repository provides a lightweight alpine-based Docker image for [bats-core](https://github.com/bats-core/bats-core), [bats-support](https://github.com/ztombol/bats-support), [bats-assert](https://github.com/ztombol/bats-assert) and [bats-file](https://github.com/ztombol/bats-file).

## Supported tags and respective Dockerfile links

- [`1.3.0`, `1.3`, `latest`](https://github.com/ffurrer2/docker-bats/blob/main/Dockerfile)

## Usage

### Command line

To run all Bats tests in the current directory, run the following command:

```bash
docker run -it --rm -v "$(pwd):/workdir" ffurrer/bats:latest .
```

### GitHub Actions

To use `bats` within GitHub Actions, add the following job to your workflow file:

```yaml
bats:
  runs-on: ubuntu-latest
  steps:
  - name: Checkout
    uses: actions/checkout@v2
  - name: bats
    uses: docker://ffurrer/bats:latest
    with:
      args: '.'
```

## Examples

### Run Bats tests of a single test file

```bash
docker run -it --rm -v "$(pwd):/workdir" ffurrer/bats my-test.bats
```

### Use `bats` options

```bash
docker run -it --rm -v "$(pwd):/workdir" ffurrer/bats --recursive --tap .
```

### Show help message

```bash
docker run -it --rm ffurrer/bats
```

### Show version

```bash
docker run -it --rm ffurrer/bats --version
```

## License

This project is licensed under the [MIT License](LICENSE).

View license information for [bats-core](https://github.com/bats-core/bats-core/blob/master/LICENSE.md), [bats-support](https://github.com/ztombol/bats-support/blob/master/LICENSE), [bats-assert](https://github.com/ztombol/bats-assert/blob/master/LICENSE) and [bats-file](https://github.com/ztombol/bats-file/blob/master/LICENSE).

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in the [repo-info repository's alpine/ directory](https://github.com/docker-library/repo-info/tree/master/repos/alpine).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
