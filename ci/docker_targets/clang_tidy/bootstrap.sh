#!/bin/sh

set -e

apt-get update

apt-get install --no-install-recommends -y \
	binutils \
	ca-certificates \
	clang-5.0 \
	clang-tidy-5.0 \
	cmake \
	curl \
	make

mkdir -p /usr/local/include/catch
curl -Lf \
	-o /usr/local/include/catch/catch.hpp \
	https://git.mel.vin/mirror/catch/raw/v2.1.1/catch/catch.hpp

apt-get purge -y \
	curl

apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

ln -s /usr/bin/clang-5.0 /usr/local/bin/cc
ln -s /usr/bin/clang++-5.0 /usr/local/bin/c++
