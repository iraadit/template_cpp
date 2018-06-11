#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	clang \
	cmake \
	g++ \
	gcc \
	libc-dev \
	make

ln -s /usr/bin/clang /usr/local/bin/cc
ln -s /usr/bin/clang++ /usr/local/bin/c++
