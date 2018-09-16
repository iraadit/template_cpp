#!/bin/sh

CATCH=2.4.0
CLANG=6.0
DEBIAN=stretch

set -e

printf '%s\n' \
	"deb http://ftp.debian.org/debian $DEBIAN-backports main" \
	> /etc/apt/sources.list.d/$DEBIAN-backports.list

apt-get update

apt-get install --no-install-recommends -y \
	binutils \
	ca-certificates \
	clang-$CLANG/$DEBIAN-backports \
	clang-format-$CLANG/$DEBIAN-backports \
	clang-tidy-$CLANG/$DEBIAN-backports \
	cmake/$DEBIAN-backports \
	curl \
	git \
	make

mkdir -p /usr/local/include/catch2
curl -Lf \
	-o /usr/local/include/catch2/catch.hpp \
	https://git.mel.vin/mirror/catch/raw/v$CATCH/catch2/catch.hpp

ln -s /usr/bin/clang-$CLANG /usr/local/bin/cc
ln -s /usr/bin/clang++-$CLANG /usr/local/bin/c++
ln -s /usr/bin/clang-format-$CLANG /usr/local/bin/clang-format
ln -s /usr/bin/clang-tidy-$CLANG /usr/local/bin/clang-tidy

apt-get purge -y \
	curl

apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
