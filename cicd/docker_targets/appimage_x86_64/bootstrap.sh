#!/bin/sh

APPIMAGE_VER=continuous
APPIMAGE=https://github.com/AppImage/AppImageKit/releases/download/$APPIMAGE_VER
DEBIAN=stretch

set -e

printf '%s\n' \
	"deb http://ftp.debian.org/debian $DEBIAN-backports main" \
	> /etc/apt/sources.list.d/$DEBIAN-backports.list

apt-get update

apt-get install --no-install-recommends -y \
	appstream \
	binutils \
	ca-certificates \
	cmake/$DEBIAN-backports \
	curl \
	file \
	g++ \
	gcc \
	git \
	gnupg \
	libc-dev \
	libcairo2 \
	make

# using FUSE from within docker is complicated and probably requires the
# container to be run in privileged mode, so we extract the AppImage instead
mkdir -p /opt/appimage
cd /opt/appimage

for i in appimagetool-x86_64.AppImage AppRun-x86_64
do
	curl -Lf -o "$i" "$APPIMAGE/$i"
	chmod 755 "$i"
done

./appimagetool-x86_64.AppImage --appimage-extract
mv squashfs-root appimagetool-x86_64

ln -s "$PWD/appimagetool-x86_64/AppRun" /usr/local/bin/appimagetool
ln -s AppRun-x86_64 AppRun

apt-get purge -y \
	curl

apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
