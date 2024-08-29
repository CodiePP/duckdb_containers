FROM alpine:latest AS builder

RUN addgroup -g 1000 squeak \
    && adduser -u 1000 -G squeak -s /bin/bash -D squeak \
    && apk update \
    && apk add --no-cache bash git rsync curl alpine-sdk cmake

#COPY --chown=1000 duckdb_Linux_x86_64 /home/squeak/duckdb

USER squeak

WORKDIR /home/squeak

RUN git clone https://github.com/duckdb/duckdb.git duckdb.git
RUN cd duckdb.git && git checkout v1.0.0
RUN cd duckdb.git && STATIC_LIBCPP=1 make -j2
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
