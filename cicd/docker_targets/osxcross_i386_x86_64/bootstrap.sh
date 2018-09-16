#!/bin/sh

CLANG=6.0
DEBIAN=stretch
XCODE=7.3
XCODE_SDK=10.11

# the Mac OSX SDK is required, two methods:
# 1. fetch full xcode and extract sdk from it, this requires downloading
#    xcode, which is several GiB, and also requires fuse to work properly in
#    the docker container
# 2. fetch a prebuilt sdk and use this, avoiding long image build times and
#    making it work without fuse, you really should use this method
# note: full dependencies for fuse are always downloaded and cleaned up later
SDK_METHOD=sdk_dl

sdk_dl()
{
	curl -Lf \
		-o tarballs/MacOSX$XCODE_SDK.sdk.tar.xz \
		https://git.mel.vin/mirror/xcode_sdk/raw/$XCODE_SDK/\
MacOSX$XCODE_SDK.sdk.tar.xz
}

sdk_xcode()
{
	curl -Lf \
		-o tarballs/xcode.dmg \
		https://git.mel.vin/mirror/xcode/raw/$XCODE/xcode.dmg
	# assume fuse works on host and is passed to docker img, example:
	# docker run --device /dev/fuse --cap-add SYS_ADMIN ...
	sed -E -i \
		-e 's/^(require modinfo)$/echo skip require modinfo #\1/' \
		-e 's/^([ \t]*modinfo fuse.*)$/echo skip modinfo fuse #\1/' \
		tools/gen_sdk_package_darling_dmg.sh
	./tools/gen_sdk_package_darling_dmg.sh \
		tarballs/xcode.dmg
	mv MacOSX*.sdk.tar.xz tarballs
}

set -e

printf '%s\n' \
	"deb http://ftp.debian.org/debian $DEBIAN-backports main" \
	> /etc/apt/sources.list.d/$DEBIAN-backports.list

apt-get update

apt-get install --no-install-recommends -y \
	autoconf \
	autogen \
	ca-certificates \
	clang-$CLANG/$DEBIAN-backports \
	cmake/$DEBIAN-backports \
	curl \
	file \
	fuse \
	git \
	libbz2-dev \
	libfuse-dev \
	libssl-dev \
	libxml2-dev \
	llvm-$CLANG/$DEBIAN-backports \
	make \
	patch \
	pkg-config \
	uuid-dev \
	xz-utils \
	zlib1g-dev

ln -s /usr/lib/llvm-$CLANG/bin/* /usr/local/bin
ln -s clang /usr/local/bin/cc
ln -s clang++ /usr/local/bin/c++

mkdir -p /opt/osxcross
cd /opt/osxcross

curl -Lf \
	-o xar-master.tar.gz \
	https://github.com/mackyle/xar/archive/master.tar.gz
tar -xf xar-master.tar.gz
cd xar-master/xar
# https://github.com/mackyle/xar/issues/18
sed -i 's/OpenSSL_add_all_ciphers/OPENSSL_init_crypto/' configure.ac
./autogen.sh --noconfigure
./configure --prefix=/usr
make -j "$(nproc)"
make install
ldconfig
cd /opt/osxcross
rm -rf xar-master xar-master.tar.gz

curl -Lf \
	-o osxcross-master.tar.gz \
	https://github.com/tpoechtrager/osxcross/archive/master.tar.gz
tar -xf osxcross-master.tar.gz
cd osxcross-master
eval "$SDK_METHOD"
UNATTENDED=1 ./build.sh
mv target /opt/osxcross_tmp
cd /opt/osxcross
rm -rf osxcross-master osxcross-master.tar.gz

cd /opt
rmdir osxcross
mv osxcross_tmp osxcross

# macports currently not supported, see docs
rm osxcross/bin/omp osxcross/bin/osxcross-mp osxcross/bin/osxcross-macports
# correct a broken symlink in SDK
rm /opt/osxcross/SDK/MacOSX$XCODE_SDK.sdk/System/Library/Frameworks/\
Kernel.framework/Versions/A/Headers/stdbool.h
ln -s stdarg.h /opt/osxcross/SDK/MacOSX$XCODE_SDK.sdk/System/Library/\
Frameworks/Kernel.framework/Versions/A/Headers/stdbool.h

ln -s /opt/osxcross/bin/* /usr/local/bin

apt-get purge -y \
	autoconf \
	autogen \
	curl \
	file \
	fuse \
	libbz2-dev \
	libfuse-dev \
	libssl-dev \
	libxml2-dev \
	patch \
	pkg-config \
	xz-utils \
	zlib1g-dev

apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
