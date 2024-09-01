# duckdb_containers

duckdb executables for Linux/x86_64, Linux/aarch64, Linux/riscv64, Darwin/x86_64, Darwin/arm64, Windows/x86_64, FreeBSD/amd64, FreeBSD/arm64

## build Docker containers

based on Alpine and musl:

`docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/riscv64 -f Dockerfile -t codieplusplus/duckdb:latest .`

based on Debian:

`docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/riscv64 -f Dockerfile.Debian -t codieplusplus/duckdb:debian_latest .`

