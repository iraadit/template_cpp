#!/bin/sh

CATCH=2.2.2
CLANG=6.0

set -e

apt-get update

apt-get install --no-install-recommends -y \
	binutils \
	ca-certificates \
	clang-$CLANG \
	clang-format-$CLANG \
	clang-tidy-$CLANG \
	cmake \
	curl \
	make

mkdir -p /usr/local/include/catch
curl -Lf \
	-o /usr/local/include/catch/catch.hpp \
	https://git.mel.vin/mirror/catch/raw/v$CATCH/catch/catch.hpp

apt-get purge -y \
	curl

apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

ln -s /usr/bin/clang-$CLANG /usr/local/bin/cc
ln -s /usr/bin/clang++-$CLANG /usr/local/bin/c++
ln -s /usr/bin/clang-format-$CLANG /usr/local/bin/clang-format
ln -s /usr/bin/clang-tidy-$CLANG /usr/local/bin/clang-tidy
