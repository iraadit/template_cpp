#!/bin/sh

set -e

echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
	>> /etc/apk/repositories

apk --no-cache add \
	binutils \
	cmake \
	g++ \
	gcc \
	lcov \
	libc-dev \
	make

apk --no-cache add -t tmp \
	curl

mkdir -p /usr/local/include/catch
curl -Lf \
	-o /usr/local/include/catch/catch.hpp \
	https://git.mel.vin/mirror/catch/raw/v2.2.1/catch/catch.hpp

apk --no-cache del tmp
