#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	g++ \
	gcc \
	git \
	libc-dev \
	make
