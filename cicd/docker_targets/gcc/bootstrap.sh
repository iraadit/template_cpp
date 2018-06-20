#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	gcc \
	git \
	libc-dev \
	make
