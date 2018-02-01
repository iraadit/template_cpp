#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	doxygen \
	graphviz \
	libc-dev \
	make
