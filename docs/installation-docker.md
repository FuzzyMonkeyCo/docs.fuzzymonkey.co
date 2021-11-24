# Installing `monkey` with Docker

This page describes the requirements and steps to install `monkey` on any platform with Docker.

If [Docker](https://docs.docker.com/get-docker/) is installed on your platform, this may be the more secure installation option.

Note: change `/usr/local/bin` to a path where you store your executables.

```shell
DOCKER_BUILDKIT=1 docker build --platform=local \
  --output /usr/local/bin \
  --build-arg PREBUILT=1 https://github.com/FuzzyMonkeyCo/monkey.git
```

TODO: tabs for mac/bun/dows/local path[.].
