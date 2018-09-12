#!/bin/sh

CATCH=2.4.0

set -e

echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
	>> /etc/apk/repositories

apk --no-cache add \
	binutils \
	cmake \
	g++ \
	gcc \
	git \
	lcov \
	libc-dev \
	make

apk --no-cache add -t tmp \
	curl

mkdir -p /usr/local/include/catch2
curl -Lf \
	-o /usr/local/include/catch2/catch.hpp \
	https://git.mel.vin/mirror/catch/raw/v$CATCH/catch2/catch.hpp

apk --no-cache del tmp
