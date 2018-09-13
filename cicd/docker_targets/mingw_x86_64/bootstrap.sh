#!/bin/sh

DEBIAN=stretch

set -e

printf '%s\n' \
	"deb http://ftp.debian.org/debian $DEBIAN-backports main" \
	> /etc/apt/sources.list.d/$DEBIAN-backports.list

apt-get update

apt-get install --no-install-recommends -y \
	binutils-mingw-w64-x86-64 \
	ca-certificates \
	cmake/$DEBIAN-backports \
	gcc-mingw-w64-x86-64 \
	git \
	make

apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
