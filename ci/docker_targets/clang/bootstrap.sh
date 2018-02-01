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

apk --no-cache add -t tmp \
	curl

mkdir -p /usr/local/include/catch
curl -Lf \
	-o /usr/local/include/catch/catch.hpp \
	https://git.mel.vin/mirror/catch/raw/v2.1.1/catch/catch.hpp

apk --no-cache del tmp

ln -s /usr/bin/clang /usr/local/bin/cc
ln -s /usr/bin/clang++ /usr/local/bin/c++
