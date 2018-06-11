#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	g++ \
	gcc \
	libc-dev \
	make
