FROM alpine:latest AS builder

RUN addgroup -g 1000 squeak \
    && adduser -u 1000 -G squeak -s /bin/bash -D squeak \
    && apk update \
    && apk add --no-cache bash git rsync curl alpine-sdk cmake ninja-build

#COPY --chown=1000 duckdb_Linux_x86_64 /home/squeak/duckdb

ARG FORGEJO_PAT
ARG FORGEJO_USER
ARG TAG_VERSION
ARG REPO_URL
ARG DUCKDB_REPO

USER squeak

WORKDIR /home/squeak

#RUN git clone https://github.com/duckdb/duckdb.git duckdb.git
RUN git clone https://${FORGEJO_USER}:${FORGEJO_PAT}@${REPO_URL}/${DUCKDB_REPO}.git duckdb.git
RUN cd duckdb.git && git checkout ${TAG_VERSION}
RUN cd duckdb.git && GEN=Ninja STATIC_LIBCPP=1 BUILD_ALL_IT_EXT=1 make -j$(nproc)
RUN strip -s duckdb.git/build/release/duckdb

FROM alpine:latest

RUN addgroup -g 1000 squeak \
    && adduser -u 1000 -G squeak -s /bin/bash -D squeak \
    && apk update \
    && apk add --no-cache bash gcompat

USER squeak

WORKDIR /home/squeak

COPY --chown=1000 --from=builder /home/squeak/duckdb.git/build/release/duckdb .

CMD bash
