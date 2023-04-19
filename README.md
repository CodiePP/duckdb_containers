# duckdb_containers

duckdb executables for Linux/x86_64, Linux/aarch64, Darwin/x86_64, Darwin/arm64, Windows/x86_64, FreeBSD/amd64, FreeBSD/arm64

## build Docker containers

`docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -f Dockerfile -t codieplusplus/duckdb:latest --push .`

