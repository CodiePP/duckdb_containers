#!/bin/sh

UNAMES=$(uname -s)
UNAMEM=$(uname -m)

DUCKDB="duckdb_${UNAMES}_${UNAMEM}"

if [ -e ${DUCKDB} ]; then
	./${DUCKDB} $*
else
	echo "no duckdb binary available for platform: ${UNAMES}_${UNAMEM}"
	exit 1
fi
