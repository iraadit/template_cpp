#!/bin/sh

set -e

apt-get update

apt-get install -y \
	clang-6.0 \
	clang-format-6.0 \
	clang-tidy-6.0 \
	cmake \
	cppcheck \
	curl \
	g++ \
	gcc \
	lcov

mkdir -p /usr/local/include/catch
curl -Lf \
	-o /usr/local/include/catch/catch.hpp \
	https://git.mel.vin/mirror/catch/raw/v2.1.1/catch/catch.hpp

apt-get clean
rm -rf /var/lib/apt/lists/*
