# Installing `monkey`

With [Docker](https://docs.docker.com/get-docker/):
```shell
DOCKER_BUILDKIT=1 docker build --platform=local \
  --output /usr/local/bin \
  --build-arg PREBUILT=1 https://github.com/FuzzyMonkeyCo/monkey.git
```

Or the less secure:
```shell
curl -#fL https://git.io/FuzzyMonkey | BINDIR=/usr/local/bin sh
```

Or finally, install [from source](https://github.com/FuzzyMonkeyCo/monkey) on GitHub.
