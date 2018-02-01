#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	gcc \
	libc-dev \
	make
