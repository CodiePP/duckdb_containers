# duckdb_containers

Docker images with duckdb executables for Linux/x86_64, Linux/aarch64, Linux/riscv64

(also have prepared at some point executables on these platforms: Darwin/x86_64, Darwin/arm64, Windows/x86_64, FreeBSD/amd64, FreeBSD/arm64)

The multi-arch container can be found at:

https://hub.docker.com/r/codieplusplus/duckdb

and pulled with: `docker pull codieplusplus/duckdb`


## preparations

```sh
TAG_VERSION="v1.4.3"
FORGEJO_USER="ci_user"
FORGEJO_PAT="123abc"
REPO_URL="code.example.com"
DUCKDB_REPO="user/duckdb"
```

## All-in-one build Docker containers

based on Alpine and musl:

`docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/riscv64 -f Dockerfile -t codieplusplus/duckdb:latest -t codieplusplus/duckdb:$TAG_VERSION --push .`

based on Debian:

`docker buildx build --platform linux/amd64,linux/arm64,linux/arm32v7,linux/riscv64 -f Dockerfile.Debian -t codieplusplus/duckdb-debian:latest -t codieplusplus/duckdb-debian:$TAG_VERSION .`


## build single Docker containers per platform and combine them

```
for Platform in amd64 arm64 riscv64; do
  echo "compiling for ${Platform}"
  docker buildx build -t ${REPO_URL}/${DUCKDB_REPO}-${TAG_VERSION#v}-${Platform} -f Dockerfile --platform linux/${Platform} --build-arg FORGEJO_USER="${FORGEJO_USER}" --build-arg FORGEJO_PAT="${FORGEJO_PAT}" --build-arg TAG_VERSION="${TAG_VERSION}" --build-arg REPO_URL="${REPO_URL}" --build-arg DUCKDB_REPO="${DUCKDB_REPO}" --push .
  echo
done
```

then, combine them into the final multi-arch image:

```
docker buildx imagetools create -t ${REPO_URL}/${DUCKDB_REPO}:${TAG_VERSION#v} \
   ${REPO_URL}/${DUCKDB_REPO}-${TAG_VERSION#v}-amd64 \
   ${REPO_URL}/${DUCKDB_REPO}-${TAG_VERSION#v}-arm64 \
   ${REPO_URL}/${DUCKDB_REPO}-${TAG_VERSION#v}-riscv64
```

and push to docker hub:
```
docker buildx imagetools create -t codieplusplus/duckdb:${TAG_VERSION#v} -t codieplusplus/duckdb:latest \
   ${REPO_URL}/${DUCKDB_REPO}-${TAG_VERSION#v}-amd64 \
   ${REPO_URL}/${DUCKDB_REPO}-${TAG_VERSION#v}-arm64 \
   ${REPO_URL}/${DUCKDB_REPO}-${TAG_VERSION#v}-riscv64
```

### the Debian based multi-arch image

```
for Platform in amd64 arm64 riscv64; do
  echo "compiling for ${Platform}"
  docker buildx build -t ${REPO_URL}/${DUCKDB_REPO}-debian-${TAG_VERSION#v}-${Platform} -f Dockerfile.Debian --platform linux/${Platform} --build-arg FORGEJO_USER="${FORGEJO_USER}" --build-arg FORGEJO_PAT="${FORGEJO_PAT}" --build-arg TAG_VERSION="${TAG_VERSION}" --build-arg REPO_URL="${REPO_URL}" --build-arg DUCKDB_REPO="${DUCKDB_REPO}" --push .
  echo
done
```

then, combine them into the final multi-arch image:

```
docker buildx imagetools create -t ${REPO_URL}/${DUCKDB_REPO}-debian:${TAG_VERSION#v} \
   ${REPO_URL}/${DUCKDB_REPO}-debian-${TAG_VERSION#v}-amd64 \
   ${REPO_URL}/${DUCKDB_REPO}-debian-${TAG_VERSION#v}-arm64 \
   ${REPO_URL}/${DUCKDB_REPO}-debian-${TAG_VERSION#v}-riscv64
```

and push to docker hub:
```
docker buildx imagetools create -t codieplusplus/duckdb-debian:${TAG_VERSION#v} -t codieplusplus/duckdb-debian:latest \
   ${REPO_URL}/${DUCKDB_REPO}-debian-${TAG_VERSION#v}-amd64 \
   ${REPO_URL}/${DUCKDB_REPO}-debian-${TAG_VERSION#v}-arm64 \
   ${REPO_URL}/${DUCKDB_REPO}-debian-${TAG_VERSION#v}-riscv64
```
