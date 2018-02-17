#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	cppcheck \
	g++ \
	gcc \
	libc-dev \
	make
