#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	cppcheck \
	gcc \
	libc-dev \
	make
